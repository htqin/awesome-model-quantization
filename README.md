# Model Quantization



A list of papers, docs, codes about model quantization. This repo is aimed to provide the info for model quantization research, we are continuously improving the project. Welcome to PR the works (papers, repositories) that are missed by the repo.



## Paper list

### 2018

| Paper                                                        |     Tags     |                      Code                       | Years |
| ------------------------------------------------------------ | :----------: | :---------------------------------------------: | :---: |
| Two-Step Quantization for Low-bit Neural Networks            | Quantization |                       --                        | 2018  |
| Towards Fast and Energy-Efficient Binarized Neural Network Inference on FPGA |   Hardware   |                       --                        | 2018  |
| Extremely Low Bit Neural Network: Squeeze the Last Bit Out with ADMM | Quantization | [Link](http://web.stanford.edu/~boyd/admm.html) | 2018  |
| PACT: PARAMETERIZED CLIPPING ACTIVATION FOR QUANTIZED NEURAL NETWORKS | Quantization |                       --                        | 2018  |

### 2017

| Paper                                                        | Tags         | Code                                                    | Years |
| ------------------------------------------------------------ | :----------: | :----------------------------------------------------------: | :---: |
| Ternary Neural Networks with Fine-Grained Quantization | Quantization | -- | 2017 |
| ShiftCNN: Generalized Low-Precision Architecture for Inference of Convolutional Neural Networks | Quantization | [Link](https://github.com/Ewenwan/caffe-quant-shiftcnn)              | 2017  |
| Towards Accurate Binary Convolutional Neural Network         | Quantization | [Link](https://github.com/layog/Accurate-Binary-Convolution-Network) | 2017  |
| Deep Learning with Low Precision by Half-wave Gaussian Quantization | Quantization | [Link](https://github.com/zhaoweicai/hwgq)                           | 2017  |
| Performance Guaranteed Network Acceleration via High-Order Residual Quantization | Quantization | --                                                         | 2017  |
| From Hashing to CNNs: Training Binary Weight Networks via Hashing | Quantization | --                                                         | 2017  |
| INCREMENTAL NETWORK QUANTIZATION: TOWARDS LOSSLESS CNNS WITH LOW-PRECISION WEIGHTS | Quantization | [Link](https://github.com/Zhouaojun/Incremental-Network-Quantization) | 2017  |
| On-chip Memory Based Binarized Convolutional Deep Neural Network Applying Batch Normalization Free Technique on an FPGA | Hardware     | --                                                         | 2017  |
| FP-BNN- Binarized neural network on FPGA                     | Hardware     | --                                                         | 2017  |
| Trained Ternary Quantization | Quantization | [Link](https://github.com/TropComplique/trained-ternary-quantization) | 2017 |

### 2016

| Paper                                                        | Tags         | Code                                                    | Years |
| ------------------------------------------------------------ | :----------: | :----------------------------------------------------------: | :---: |
| Ternary weight networks | Quantization | [Link](https://github.com/fengfu-chris/caffe-twns) | 2016 |
| DoReFa-Net: Training Low Bitwidth Convolutional Neural Networks with Low Bitwidth Gradients | Quantization | [Link](https://github.com/tensorpack/tensorpack/tree/master/examples/DoReFa-Net) | 2016 |
| XNOR-Net- ImageNet Classification Using Binary Convolutional Neural Networks | Quantization | [Link](https://github.com/allenai/XNOR-Net)                         | 2016  |
| Binarized Neural Networks: Training Deep Neural Networks with Weights and Activations Constrained to +1 or -1 | Quantization | [Link](https://github.com/itayhubara/BinaryNet)                      | 2016  |
| BinaryNet: Training Deep Neural Networks with Weights and Activations Constrained to +1 or -1 | Quantization | [Link](https://github.com/MatthieuCourbariaux/BinaryNet)             | 2016  |

### 2015

| Paper                                                        | Tags         | Code                                                    | Years |
| ------------------------------------------------------------ | :----------: | :----------------------------------------------------------: | :---: |
| Bitwise Neural Networks | Quantization | -- | 2015 |
| BinaryConnect- Training Deep Neural Networks with binary weights during propagations | Quantization | [Link](https://github.com/MatthieuCourbariaux/BinaryConnect)         | 2015  |



## Related Codes

| Code             | From                                                         | Description                                          |
| ---------------- | ------------------------------------------------------------ | ---------------------------------------------------- |
| PyTorch-Quant.py | https://github.com/Ewenwan/pytorch-playground/blob/master/utee/quant.py | Different quantization methods implement by Pytorch. |
| ZF-Net           | https://support.alpha-data.com/pub/appnotes/cnn/             | An Open Source FPGA CNN Library                      |



## Docs

| Doc                                               | Description                                          |
| ------------------------------------------------- | ---------------------------------------------------- |
| QuantizationMethods.md                            | Quantization Methods                                 |
| Embedded Deep Learning.md                         | Run BNN in FPGA                                      |
| An Open Source FPGA CNN Library.pdf               | Code: ZF-Net, Doc of An Open Source FPGA CNN Library |
| Accelerating CNN inference on FPGAs- A Survey.pdf | Accelerating CNN inference on FPGAs: A Survey.       |



#### Reference

* https://www.codercto.com/a/30037.html

*  https://github.com/Ewenwan/MVision/tree/master/CNN/Deep_Compression/

* https://github.com/Ewenwan/pytorch-playground/blob/master/utee/quant.py

* https://github.com/Ewenwan/MVision/tree/master/CNN/Deep_Compression/quantization

* https://mp.weixin.qq.com/s/RsZCTqCKwpnjATUFC8da7g