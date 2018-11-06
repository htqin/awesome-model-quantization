# Quantization Methods

找到了一份用PyTorch写的Quantization总结代码，在这里学习一下方法和写法。

## 量化方法

1. 线性量化

   ```python
   def linear_quantize(input, sf, bits):
       assert bits >= 1, bits
       # 一位
       if bits == 1:
           return torch.sign(input) - 1
       delta = math.pow(2.0, -sf)# 小数位 位宽 量化精度
       bound = math.pow(2.0, bits-1)
       min_val = - bound    # 上限制值
       max_val = bound - 1  # 下限值
       rounded = torch.floor(input / delta + 0.5)# 扩大后取整
       clipped_value = torch.clamp(rounded, min_val, max_val) * delta# 再缩回
       return clipped_value
   ```

   **线性量化：**从32-bit float量化为n-bit。如果n==1，直接取sign；其他情况，先确定量化上界bound和量化增量delta，按照增量对input扩大后取整分组，zhihou将输入round张量每个元素的夹紧到区间(min,max)，并返回最终结果到clipped_value。

2. MinMax量化

   ```python
   def min_max_quantize(input, bits):
       assert bits >= 1, bits
       if bits == 1:
           return torch.sign(input) - 1
       min_val, max_val = input.min(), input.max()
       if isinstance(min_val, Variable):
           max_val = float(max_val.data.cpu().numpy()[0])
           min_val = float(min_val.data.cpu().numpy()[0])
       input_rescale = (input - min_val) / (max_val - min_val)
       n = math.pow(2.0, bits) - 1
       v = torch.floor(input_rescale * n + 0.5) / n
       v =  v * (max_val - min_val) + min_val
   ```

   **MinMax量化：**在min_max_quantize中，首先将input中的所有参数放缩到(0,1)之间，再按照bit数扩大之后取整分组，之后再按原先比例重新扩张。

3. 非线性对数量化

   ```python
   def log_minmax_quantize(input, bits):
       assert bits >= 1, bits
       if bits == 1:
           return torch.sign(input), 0.0, 0.0
       s = torch.sign(input)#  正负号
       input0 = torch.log(torch.abs(input) + 1e-20)# 对数值 得到2的对数 位宽
       v = min_max_quantize(input0, bits)
       v = torch.exp(v) * s
       return v
   ```

   **非线性对数量化：**从32-bit float量化为n-bit。如果n==1，直接取sign；其他情况，先取sign得到符号矩阵，之后对input的绝对值取2对数（防止为0加一个极小数），将对数处理过后的input0放入min_max_quantize。返回min_max_quantize得到的数组，取对数乘符号矩阵，得到最终量化结果。

4. 线性对数量化

   ``` python
   def log_linear_quantize(input, sf, bits):
       assert bits >= 1, bits
       if bits == 1:
           return torch.sign(input), 0.0, 0.0
       s = torch.sign(input)# 正负号
       input0 = torch.log(torch.abs(input) + 1e-20)# 比特位
       v = linear_quantize(input0, sf, bits)#对比特位进行量化
       v = torch.exp(v) * s# 再指数 回 原数
       return v
   ```

   **线性对数量化：**从32-bit float量化为n-bit。如果n==1，直接取sign；其他情况，先取sign得到符号矩阵，之后对input的绝对值取2对数（防止为0加一个极小数），将对数处理过后的input0放入linear_quantize。返回linear_quantize得到的数组，取对数乘符号矩阵，得到最终量化结果。

5. Tanh量化

   ```python
   def tanh_quantize(input, bits):
       assert bits >= 1, bits
       if bits == 1:
           return torch.sign(input)
       input = torch.tanh(input) # [-1, 1]
       input_rescale = (input + 1.0) / 2 #[0, 1]
       n = math.pow(2.0, bits) - 1
       v = torch.floor(input_rescale * n + 0.5) / n
       v = 2 * v - 1 # [-1, 1]
       v = 0.5 * torch.log((1 + v) / (1 - v)) # arctanh
       return v
   ```

   **Tanh量化：**从32-bit float量化为n-bit。如果n==1，直接取sign；其他情况，先将input使用tanh映射到(-1,1)，之后将input压缩至(0,1)区间，再按照bit数扩大之后取整分组，再按照压缩的方法逆向扩张到(-1,1)，再使用arctanh重新恢复。



## 量化类设计

```python
class LinearQuant(nn.Module):
    def __init__(self, name, bits, sf=None, overflow_rate=0.0, counter=10):
        super(LinearQuant, self).__init__()
        self.name = name
        self._counter = counter
        self.bits = bits
        self.sf = sf
        self.overflow_rate = overflow_rate
        
    @property
    def counter(self):
        return self._counter

    def forward(self, input):
        if self._counter > 0:
            self._counter -= 1
            sf_new = self.bits - 1 - compute_integral_part(input, self.overflow_rate)
            self.sf = min(self.sf, sf_new) if self.sf is not None else sf_new
            return input
        else:
            output = linear_quantize(input, self.sf, self.bits)
            return output

    def __repr__(self):
        return '{}(sf={}, bits={}, overflow_rate={:.3f}, counter={})'.format(
            self.__class__.__name__, self.sf, self.bits, self.overflow_rate, self.counter)

class LogQuant(nn.Module):
    def __init__(self, name, bits, sf=None, overflow_rate=0.0, counter=10):
        super(LogQuant, self).__init__()
        self.name = name
        self._counter = counter

        self.bits = bits
        self.sf = sf
        self.overflow_rate = overflow_rate

    @property
    def counter(self):
        return self._counter

    def forward(self, input):
        if self._counter > 0:
            self._counter -= 1
            log_abs_input = torch.log(torch.abs(input))
            sf_new = self.bits - 1 - compute_integral_part(log_abs_input, self.overflow_rate)
            self.sf = min(self.sf, sf_new) if self.sf is not None else sf_new
            return input
        else:
            output = log_linear_quantize(input, self.sf, self.bits)
            return output

    def __repr__(self):
        return '{}(sf={}, bits={}, overflow_rate={:.3f}, counter={})'.format(
            self.__class__.__name__, self.sf, self.bits, self.overflow_rate, self.counter)

class NormalQuant(nn.Module):
    def __init__(self, name, bits, quant_func):
        super(NormalQuant, self).__init__()
        self.name = name
        self.bits = bits
        self.quant_func = quant_func

    @property
    def counter(self):
        return self._counter

    def forward(self, input):
        output = self.quant_func(input, self.bits)
        return output

    def __repr__(self):
        return '{}(bits={})'.format(self.__class__.__name__, self.bits)
```

## 量化过程设计

```python
def duplicate_model_with_quant(model, bits, overflow_rate=0.0, counter=10, type='linear'):
    """assume that original model has at least a nn.Sequential"""
    assert type in ['linear', 'minmax', 'log', 'tanh']
    if isinstance(model, nn.Sequential):
        l = OrderedDict()
        for k, v in model._modules.items():
            if isinstance(v, (nn.Conv2d, nn.Linear, nn.BatchNorm1d, nn.BatchNorm2d, nn.AvgPool2d)):
                l[k] = v
                if type == 'linear':
                    quant_layer = LinearQuant('{}_quant'.format(k), bits=bits, overflow_rate=overflow_rate, counter=counter)
                elif type == 'log':
                    # quant_layer = LogQuant('{}_quant'.format(k), bits=bits, overflow_rate=overflow_rate, counter=counter)
                    quant_layer = NormalQuant('{}_quant'.format(k), bits=bits, quant_func=log_minmax_quantize)
                elif type == 'minmax':
                    quant_layer = NormalQuant('{}_quant'.format(k), bits=bits, quant_func=min_max_quantize)
                else:
                    quant_layer = NormalQuant('{}_quant'.format(k), bits=bits, quant_func=tanh_quantize)
                l['{}_{}_quant'.format(k, type)] = quant_layer
            else:
                l[k] = duplicate_model_with_quant(v, bits, overflow_rate, counter, type)
        m = nn.Sequential(l)
        return m
    else:
        for k, v in model._modules.items():
            model._modules[k] = duplicate_model_with_quant(v, bits, overflow_rate, counter, type)
        return model
```

