## 嵌入式深度学习之神经网络二值化

[TOC]

### 1. 导论

![屏幕快照 2018-11-03 下午4.01.34](https://ws1.sinaimg.cn/large/006tNbRwly1fwvsu1052pj31200msgpv.jpg)

[来源][https://ai.intel.com/accelerating-neural-networks-binary-arithmetic/]

传统神经网络于二值化神经网络的对比：1. Product-Sum替换为XNOR-Bit counting；2. Non-linearity替换为sign。

#### 二值化方法

对于weight和activation的二值化，存在两种方法：**随机二值化**和**确定二值化**

随机二值化：（需要生成随机数，硬件不友好）

![屏幕快照 2018-11-03 下午4.11.09](https://ws3.sinaimg.cn/large/006tNbRwly1fwvsty6q7pj312y0go0w4.jpg)

确定二值化：

![屏幕快照 2018-11-03 下午4.10.59](https://ws2.sinaimg.cn/large/006tNbRwly1fwvstzluwxj31320cata5.jpg)

#### 二值化网络的梯度估计

当二值化神经网络做训练的时候，会使用二值化的权重和激活函数。但是随机梯度下降是在一个小的并且有噪声的范围内使用一个小的步进单位来实现的。为了保证高精度，所以对于步进长度来说就需要达到更高的分辨率。所以当计算和累计梯度的时候，使用实数来实现。直通估计量(straight-through estimator)被用来传递梯度。从公式上看，它既保留了梯度信息，又消除了当r很大的时候的梯度。它的导数是一个hard tanh函数。

![屏幕快照 2018-11-03 下午4.22.37](https://ws4.sinaimg.cn/large/006tNbRwly1fwvstvacgwj313e0gajsk.jpg)

#### Shift Batch Normalization

于全精度的卷积神经网络，批标准化要计算出标准差而且要除以批的方差，如下图所示，计算批正则化的过程中，有乘除操作。对于二值化网络而言，用2的次方和按位位移来实现乘除的近似操作，这个被称为位移批标准化(Shift Batch Normalization)。![屏幕快照 2018-11-03 下午4.26.58](https://ws3.sinaimg.cn/large/006tNbRwly1fwvsu0j7k8j30u40nytbn.jpg)

![屏幕快照 2018-11-03 下午4.27.13](https://ws3.sinaimg.cn/large/006tNbRwly1fwvstwspy7j30tg0jcwi1.jpg)

Shift Base BN出现在文章Binarized Neural Networks-Training Neural Networks with Weights and Activations Constrained to +1 or −1当中。

![屏幕快照 2018-11-03 下午4.29.57](https://ws1.sinaimg.cn/large/006tNbRwly1fwvstz51y0j31380k841x.jpg)

#### 评价指标

最后我们从三个方面来评估二值化神经网络的性能：**功耗，内存大小，执行时间**。

随着比特位数的减少，乘法器和加法器的功耗也随之减少。

内存访问功耗跟内存大小是成正比的。二值化神经网络相比于全精度神经网络内存大小减少了32倍，随之访问存储器也少了32倍。

从执行时间来看，二值化神经网络也是最快的。因此二值化神经网络相比传统的CNN 更适合在嵌入式系统中使用

#### Code

https://github.com/MatthieuCourbariaux/BinaryNet

### 2. 异或神经网络

![屏幕快照 2018-11-03 下午4.39.08](https://ws2.sinaimg.cn/large/006tNbRwly1fwvstw24p4j31540ccgnn.jpg)

#### 综述

相比于权重二值化神经网络，异或神经网络将网络的输入也转化为二进制值，所以，异或神经网络中的乘法加法(**M**ultiplication and **AC**cumulation)运算用按位异或(XNOR)和数1的个数(popcount)来代替。

从**内存消耗**上来看，对于相同的网络结构，异或神经网络和二值化神经网络存储相同大小的权重。从**计算量**来看，异或神经网络的运算速度是全精度卷积神经网络的58倍，是二值化神经网络的29倍。由于卷积运算被按位运算代替，速度提升非常显著.

在ImageNet上，**精度损失**了大概10%。

两者关于卷积运算的对比如下：

![屏幕快照 2018-11-03 下午4.52.19](https://ws1.sinaimg.cn/large/006tNbRwly1fwvstud4boj313g0lo77c.jpg)

二值化网络于异或神经网络运算不同：前者用加减模拟，后者用XNOR-Bit counting模拟（速度更快！）。

![屏幕快照 2018-11-03 下午4.56.54](https://ws3.sinaimg.cn/large/006tNbRwly1fwvstzyme7j316s0jwn0h.jpg)

XNOR-Net中，涉及scale factor的部分如上图，ineffcient的部分是因为涉及重复计算，所以采用channel group进行估计。

![屏幕快照 2018-11-03 下午4.57.10](https://ws2.sinaimg.cn/large/006tNbRwly1fwvsu5k1lsj313w08mjsc.jpg)

XNOR-Net进行了结构上的改变，减少精度损失，具体原因：全精度神经网络中，一个典型的模块是由卷积(Conv)->批标准化(BNorm)->激活(Activ)->池化(Pool)这样的顺序操作组成的。对于异或神经网络，设计出的模块是由批标准化(BNorm)->二值化激活(BinActiv)->二值化卷积(BinConv)->池化(Pool)的顺序操作完成。这样做的原因是批标准化以后，保证了输入均值为0，然后进行二值化激活，保证了数据为-1或者+1，然后进行二值化卷积，这样能最大程度上减少特征信息的损失。

### 3. FPGA实现

#### 硬件优缺点对比

对于CPU+DSP/GPU来说，网络架构的灵活性是最大的，而且支持高精度的神经网络，易于实现扩展，控制成本。但是对于**实际的消费电子应用场景对神经网络的实时性(Real-time)，能耗和延时性(Latency)要求比较高**，在这种情况下，CPU+DSP/GPU的优势就没有FPGA和ASIC明显了。

FPGA相对于ASIC来说，**灵活性高了不少，开发周期也缩短了，而且多数ASIC前期也是使用FPGA进行验证**。

**神经网络因其网络特性(multiplelayers and multiple feature maps per layer)，对于并行化(Parallel)和流水线化(Pipeline)有着巨大的需求**。尽管GPU能提供并行化和流水线处理，但是延时和功耗上比FPGA差的比较多。FPGA上对于神经网络上的每个乘加器(MAC)可以定制化为一个模块(Block)，可以将每个模块进行并行化和流水线处理。这已经大大的加快了神经网络的处理速度，但是还不足够。

#### FPGA介绍

FPGA内的逻辑元件包括：与门、或门、非门、三态门、加法器、乘法器。但是并不是所有的逻辑器件的运算效率的都一样。

当神经网络二值化以后，乘加器(MAC)可以被更简单的异或门和按位计数（XNOR - Bit counting）所代替，在牺牲一定精确度的条件下，换取了巨大的算力增长和功耗减少。随着HLS  High level synthesis （一种在高层次将算法转化为电路描述方法）的发展，越来越容易将C语言等高级语言转换成FPGA的实现。也使得神经网络在FPGA的验证变得更简单。

#### Run BNN in FPGA

[Paper][ http://www.csl.cornell.edu/~zhiruz/pdfs/bnn-fpga2017.pdf]

[Github][ https://github.com/cornell-zhang/bnn-fpga]

在FPGA2017和FPGA2018顶会上有很多团队介绍了各自FPGA神经网络加速器的成果，本文摘选了其中一篇文章来作为二值化卷积神经网络的FPGA实现的介绍。大家这可以在文章底部找到原文。

##### 网络介绍

这篇论文主要工作是基于xilinx的Zedboard FPGA实现了二值化神经网络的推理部分(inference)，用HLS设计方法来开发。本论文选取了一个比较简单的二值化神经网络来做实现，网络结构如下图，**包含6个卷积层，3个池化层和3个全连接层**。用于做Cifar-10的分类任务。

![屏幕快照 2018-11-03 下午6.32.42](https://ws3.sinaimg.cn/large/006tNbRwly1fwvsu5f20dj312s0g60uh.jpg)

##### 网络参数分析

该神经网络的具体结构和权重的比特数计算如下图所示，整个神经网络使用了13.4Mbits(~1.675MB)的权重，卷积层和全连接层分别占4.36Mbits(~0.545MB)和9.01Mbits(~1.126MB)。全连接层由于是点对点的连接，需要的权重比较多，8192x1024+1024x1024+1024x10=9.01Mbits。另外可以注意到输出的最大维度是128Kbits，但是一层的权重最大可以消耗2.3Mbits。权重的计算后面我们可以找一个例子详细分析。

![屏幕快照 2018-11-03 下午6.45.56](https://ws2.sinaimg.cn/large/006tNbRwly1fwvstx7awgj30ty0ocdj0.jpg)

##### 结构改变

下图介绍了一般卷积神经网络和二值化卷积神经网络中卷积层处理的区别，相对比卷积神经网络，二值化神经网络的**卷积层省略了偏置和激活函数，加入了批标准化和二值化，并且接收的输入是二值化输入数据**。

![屏幕快照 2018-11-03 下午6.47.00](https://ws4.sinaimg.cn/large/006tNbRwly1fwvstux6boj30ra0ucdj2.jpg)

这里需要注意是本文的二值化神经网络做完**卷积操作以后就进行池化，卷积的结果是整型，针对池化的结果来做批标准化，批标准化是基于整型来做的。通过线性平移来保证输入分布的均值为0，方差为1，这样尽可能减少输入的损失，然后进行二值化处理，得到这一层的输出**。

![屏幕快照 2018-11-03 下午6.50.27](https://ws4.sinaimg.cn/large/006tNbRwly1fwvstykclij311k0madji.jpg)

#### FPGA设计

整个FPGA系统架构图如图(a)所示，主要由三个计算单元，一个数据缓冲区，一个DMA加上一个FSM的控制器组成。三个计算单元分别是FP-Conv，针对第一层非二值化的输入。Bin-Conv是二值化的卷积操作，Bin-FC是二值化的全连接操作。

![屏幕快照 2018-11-03 下午6.56.17](https://ws2.sinaimg.cn/large/006tNbRwly1fwvstxlcstj311y0b441c.jpg)

之前提到了，**二值化神经网络里面特征图的最大维度是128Kbits**，对于中低端的FPGA来说，**是完全可以放在片上的**，所以这里用了Buffer A和Buffer B来缓存每一层的输入和输出特征图，当Buffer A缓存输入时，Buffer B用来缓存卷积之后的输出，然后Buffer B作为输入给计算单元，Buffer A就用来缓存输出。以时间来换空间，这种架构latency比较大，可以算是串行架构，但是省了比较多的Memory。对于权重来说，片上的Memory是不够存储全部权重的，所以引入了Param Buffers来更新每一层用到的权重，通过DMA来衔接片内和片外的内存。

图(b)展示的是一个Bin-Conv的架构图，因为整个神经网络中，**卷积层消耗了最多的计算资源和运算时间**，为了达到神经网络加速的目的，卷积层的设计必须兼顾带宽和资源。这里引入了两个关键模块，一个是使用了可变位宽的行缓存(VWLB)，一个是Bitsel位选择器。

![屏幕快照 2018-11-04 上午9.37.34](https://ws3.sinaimg.cn/large/006tNbRwly1fwvsths1nfj313y0bgk0j.jpg)

可变位宽的行缓存能支持最低8bit一个字节最高32bit一个字节的输入，保证了存储器的最大利用率，位选择器可以帮助缓存不同位宽的数据，存入不同的行缓存里面，也可以保证卷积和数据的对应。下图展示了Bitsel和Line Buffer工作的例子，当输入为32bit时，因为行缓存的最大位宽为32bit，Bitsel不做操作，直接存入每一行，当输入为8bit时，Bitsel会分别填充到行缓存里面，对应可以填充4行的8bit数据。



对于每个BitConv单元，包含两个行缓存bank和两个卷积器，对特征图进行[乒乓存储][https://baike.baidu.com/item/%E4%B9%92%E4%B9%93%E6%93%8D%E4%BD%9C]，然后分别做卷积，提升了位卷积模块的吞吐量。

#### 总结

![屏幕快照 2018-11-04 上午9.37.45](https://ws2.sinaimg.cn/large/006tNbRwly1fwvst02iaqj30po0ciagv.jpg)

**相比于高精度卷积神经网络，在FPGA上使用二值化神经网络的优势有两点:**

1. 传统卷积神经网络的乘积(MAC)操作被二值化神经网络中的按位异或(bitwise XNOR)操作所取代，更适合于FPGA中LUT的实现。
2. 在同等多的特征图和全连接层的情况下，二值化权重和二值化特征图极大降低了内存的大小，突破了片内和片外的内存访问带宽。这降低了FPGA的实现难度。

**针对硬件设计，本文的使用了三个优化技巧:**

1. 通过实验表明，偏置项设为0以后对于测试精度的影响不大，Test error为11.32%。
2. 在批标准化中，引入了线性变换，y=kx+h，其中k和h被量化为16bit精度，适合做平移操作，同时对输入的浮点型进行定点化。
3. 在原有的网络中，对边界使用了零填充，但是在二值化神经网络里面，没有0，只有+1，-1，所以这里使用+1去填充边界。对于精度影响不是很大。但是在FPGA实现里面，考虑到资源问题，还是使用了零填充。

具体实现请参考github上的源码，HLS的code可以在xilinx的zynq7020平台上跑。论文作者用C++优化的模型和加速器的实现进行了对比，FPGAb并没有精度上的损失。对比python实现， FPGA的结果更好。

总的来说，FPGA上的加速相比于CPU和mGPU来说，速度，功耗和成本上都有明显的优势。进一步，FPGA作为神经网络的原型验证，易于porting到ASIC实现，如果产品的需求比较大，是很适合将FPGA原型转化为ASIC的。

