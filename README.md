# Awesome Model Quantization [![Awesome](https://awesome.re/badge.svg)](https://awesome.re)

This repo collects papers, docs, codes about model quantization for anyone who wants to do research on it. We are continuously improving the project. Welcome to PR the works (papers, repositories) that are missed by the repo.

## Table of Contents

- [Survey Papers](#Survey_Papers)
  - [Survey of Binarization](#Survey_of_Binarization)
  - [Survey of Quantization](#Survey_of_Quantization)
- [Benchmark](#Benchmark)
- [Papers](#Papers)
  - [2022](#2022)
  - [2021](#2021)
  - [2020](#2020)
  - [2019](#2019)
  - [2018](#2018)
  - [2017](#2017)
  - [2016](#2016)
  - [2015](#2015)
- [Codes and Docs](#Codes\_and\_Docs)
- [Our Team](#Our_Team)


## Survey_Papers

### Survey_of_Binarization

Our survey paper **Binary Neural Networks: A Survey** (*Pattern Recognition*) is a comprehensive survey of recent progress in binary neural networks. For details, please refer to:

**Binary Neural Networks: A Survey**  [[Paper](https://arxiv.org/abs/2004.03333)]  [[Blog](https://mp.weixin.qq.com/s/QGva6fow9tad_daZ_G2p0Q)]

[**Haotong Qin**](https://htqin.github.io/), [Ruihao Gong](https://xhplus.github.io/), [Xianglong Liu*](http://sites.nlsde.buaa.edu.cn/~xlliu/), Xiao Bai, [Jingkuan Song](https://cfm.uestc.edu.cn/~songjingkuan/), and [Nicu Sebe](https://disi.unitn.it/~sebe/).

<details><summary>Bibtex</summary><pre><code>@article{Qin:pr20_bnn_survey,
    title = "Binary neural networks: A survey",
    author = "Haotong Qin and Ruihao Gong and Xianglong Liu and Xiao Bai and Jingkuan Song and Nicu Sebe",
    journal = "Pattern Recognition",
    volume = "105",
    pages = "107281",
    year = "2020"
}</code></pre></details>

![survey](./Imgs/survey.png)

### Survey_of_Quantization

The survey paper **A Survey of Quantization Methods for Efficient Neural Network Inference** (ArXiv) is a comprehensive survey of recent progress in quantization. For details, please refer to:

**A Survey of Quantization Methods for Efficient Neural Network Inference** [[Paper](https://arxiv.org/abs/2103.13630)]

Amir Gholami\* , Sehoon Kim\* , Zhen Dong\* , Zhewei Yao\* , Michael W. Mahoney, Kurt Keutzer. (\* Equal contribution)

<details><summary>Bibtex</summary><pre><code>@misc{gholami2021survey,
      title={A Survey of Quantization Methods for Efficient Neural Network Inference}, 
      author={Amir Gholami and Sehoon Kim and Zhen Dong and Zhewei Yao and Michael W. Mahoney and Kurt Keutzer},
      year={2021},
      eprint={2103.13630},
      archivePrefix={arXiv},
      primaryClass={cs.CV}
}</code></pre></details>


## Benchmark

### MQBench

The paper **MQBench: Towards Reproducible and Deployable Model Quantization Benchmark** (*NeurIPS 2021*) is a benchmark and framework for evluating the quantization algorithms under real world hardware deployments. For details, please refer to:

**MQBench: Towards Reproducible and Deployable Model Quantization Benchmark**  [[Paper](https://arxiv.org/abs/2004.03333)]  [[Project](http://mqbench.tech/)]

Yuhang Li, Mingzhu Shen, Jian Ma, Yan Ren, Mingxin Zhao, Qi Zhang, [Ruihao Gong](https://xhplus.github.io/), Fengwei Yu, Junjie Yan.

<details><summary>Bibtex</summary><pre><code>@article{2021MQBench,
  title = "MQBench: Towards Reproducible and Deployable Model Quantization Benchmark",
  author= "Yuhang Li* and Mingzhu Shen* and Jian Ma* and Yan Ren* and Mingxin Zhao* and Qi Zhang* and Ruihao Gong and Fengwei Yu and Junjie Yan",
  journal = "https://openreview.net/forum?id=TUplOmF8DsM",
  year = "2021"
}</code></pre></details>

## Papers

**Keywords**: **`qnn`**: quantized neural networks | **`bnn`**: binarized neural networks | **`hardware`**: hardware deployment | **`snn`**: spiking neural networks | __`other`__ 

**Statistics**:  :fire: highly cited | :star: code is available and star > 50

------

### 2022
- [[IJCAI](https://arxiv.org/abs/2202.06483)] BiFSMN: Binary Neural Network for Keyword Spotting.  [__`bnn`__]
- [[IJCAI](https://arxiv.org/abs/2111.13824)] FQ-ViT: Post-Training Quantization for Fully Quantized Vision Transformer.  [__`qnn`__] [[torch](https://github.com/megvii-research/FQ-ViT)] [71:star:]
- [[ICLR](https://openreview.net/forum?id=_CfpJazzXT2)] F8Net: Fixed-Point 8-bit Only Multiplication for Network Quantization. [**`qnn`**]
- [[ICLR](https://openreview.net/forum?id=shpkpVXzo3h)] 8-bit Optimizers via Block-wise Quantization. [**`qnn`**]
- [[ICLR](https://openreview.net/forum?id=3HJOA-1hb0e)] Toward Efficient Low-Precision Training: Data Format Optimization and Hysteresis Quantization. [**`qnn`**]
- [[ICLR](https://openreview.net/forum?id=5xEgrl_5FAJ)] BiBERT: Accurate Fully Binarized BERT. [**`bnn`**][[code](https://github.com/htqin/BiBERT)]
- [[ICLR](https://openreview.net/forum?id=kF9DZQQrU0w)] Information Bottleneck: Exact Analysis of (Quantized) Neural Networks. [**`qnn`**]
- [[ICLR](https://openreview.net/forum?id=ySQH0oDyp7)] QDrop: Randomly Dropping Quantization for Extremely Low-bit Post-Training Quantization. [**`qnn`**]
- [[ICLR](https://openreview.net/forum?id=JXhROKNZzOc)] SQuant: On-the-Fly Data-Free Quantization via Diagonal Hessian Approximation. [**`qnn`**][[code](https://github.com/clevercool/SQuant)]
- [[ICLR](https://openreview.net/forum?id=ySQH0oDyp7)] Optimal ANN-SNN Conversion for High-accuracy and Ultra-low-latency Spiking Neural Networks. [**`snn`**]
- [[ICLR](https://openreview.net/forum?id=7udZAsEzd60)] VC dimension of partially quantized neural networks in the overparametrized regime. [**`qnn`**]
- [[arxiv](https://arxiv.org/pdf/2201.07703.pdf)] Q-ViT: Fully Differentiable Quantization for Vision Transformer [__`qnn`__] 

### 2021

- [[ACM MM](https://dl.acm.org/doi/10.1145/3474085.3475224)] VQMG: Hierarchical Vector Quantised and Multi-hops Graph Reasoning for Explicit Representation Learning. [__`other`__]
- [[ACM MM](https://arxiv.org/abs/2011.14265)] Fully Quantized Image Super-Resolution Networks. [**`qnn`**]
- [[NeurIPS](https://openreview.net/forum?id=ejo1_Weiart)] Qimera: Data-free Quantization with Synthetic Boundary Supporting Samples. [__`qnn`__]
- [[NeurIPS](https://openreview.net/forum?id=9TX5OsKJvm)] Post-Training Quantization for Vision Transformer. [__`mixed`__]
- [[NeurIPS](https://openreview.net/forum?id=qe9z54E_cqE)] Post-Training Sparsity-Aware Quantization. [__`qnn`__]
- [[NeurIPS](https://openreview.net/forum?id=Z_J5bCb4Rra)] Divergence Frontiers for Generative Models: Sample Complexity, Quantization Effects, and Frontier Integrals. 
- [[NeurIPS](https://openreview.net/forum?id=EO-CQzgcIxd)] VQ-GNN: A Universal Framework to Scale up Graph Neural Networks using Vector Quantization. [__`other`__]
- [[NeurIPS](https://openreview.net/forum?id=0kCxbBQknN)] Qu-ANTI-zation: Exploiting Quantization Artifacts for Achieving Adversarial Outcomes . 
- [[NeurIPS](https://openreview.net/forum?id=YygA0yppTR)] A Winning Hand: Compressing Deep Networks Can Improve Out-of-Distribution Robustness. [**`bnn`**] [[torch](https://github.com/chrundle/biprop)]
- [[CVPR](https://arxiv.org/abs/2103.01049)] Diversifying Sample Generation for Accurate Data-Free Quantization. [__`qnn`__]
- [[CVPR](https://arxiv.org/abs/2103.07156)] Learnable Companding Quantization for Accurate Low-bit Neural Networks. [__`qnn`__] 
- [[CVPR](https://arxiv.org/abs/2103.15263)] Zero-shot Adversarial Quantization. [__`qnn`__] [[torch](https://github.com/FLHonker/ZAQ-code)]
- [[CVPR](https://arxiv.org/abs/2012.15823)] Binary Graph Neural Networks. [**`bnn`**] [[torch](https://github.com/mbahri/binary_gnn)]
- [[CVPR](https://arxiv.org/abs/2104.00903)] Network Quantization with Element-wise Gradient Scaling. [__`qnn`__] [[torch](https://github.com/cvlab-yonsei/EWGS)]
- [[ICLR](https://openreview.net/forum?id=9QLRCVysdlO)] BiPointNet: Binary Neural Network for Point Clouds. [**`bnn`**] [[torch](https://github.com/htqin/BiPointNet)]
- [[ICLR](https://openreview.net/forum?id=sTeoJiB4uR)] Reducing the Computational Cost of Deep Generative Models with Binary Neural Networks. [**`bnn`**] 
- [[ICLR](https://openreview.net/forum?id=MxaY4FzOTa)] High-Capacity Expert Binary Networks. [**`bnn`**] 
- [[ICLR](https://openreview.net/forum?id=U_mat0b9iv)] Multi-Prize Lottery Ticket Hypothesis: Finding Accurate Binary Neural Networks by Pruning A Randomly Weighted Network. [**`bnn`**] 
- [[ICLR](https://openreview.net/forum?id=POWv6hDd9XH)] BRECQ: Pushing the Limit of Post-Training Quantization by Block Reconstruction. [__`qnn`__] [[torch](https://github.com/yhhhli/BRECQ)]
- [[ICLR](https://openreview.net/forum?id=EoFNy62JGd)] Neural gradients are near-lognormal: improved quantized and sparse training. [__`qnn`__] 
- [[ICLR](https://openreview.net/forum?id=dV19Yyi1fS3)] Training with Quantization Noise for Extreme Model Compression. [__`qnn`__] 
- [[ICLR](https://openreview.net/forum?id=3SV-ZePhnZM)] Incremental few-shot learning via vector quantization in deep embedded space. [__`qnn`__] 
- [[ICLR](https://openreview.net/forum?id=NSBrFgJAHg)] Degree-Quant: Quantization-Aware Training for Graph Neural Networks. [__`qnn`__] 
- [[ICLR](https://openreview.net/forum?id=TiXl51SCNw8)] BSQ: Exploring Bit-Level Sparsity for Mixed-Precision Neural Network Quantization. [__`qnn`__] 
- [[ICLR](https://openreview.net/forum?id=Qr0aRliE_Hb)] Simple Augmentation Goes a Long Way: ADRL for DNN Quantization. [__`qnn`__] 
- [[ICLR](https://openreview.net/forum?id=pBqLS-7KYAF)] Sparse Quantized Spectral Clustering. [__`qnn`__] 
- [[ICLR](https://arxiv.org/pdf/2007.13242.pdf)] WrapNet: Neural Net Inference with Ultra-Low-Resolution Arithmetic. [__`qnn`__] 
- [[ECCV](https://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123700562.pdf)] PAMS: Quantized Super-Resolution via Parameterized Max Scale. [__`qnn`__] 
- [[AAAI](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwj4-rjuq7nvAhUVPH0KHXlYCUQQFjAFegQIChAD&url=https%3A%2F%2Fwww.aaai.org%2FAAAI21Papers%2FAAAI-7144.ZhaoK.pdf&usg=AOvVaw3dnOXfzKkLIw_qWXj7p7Yc)] Distribution Adaptive INT8 Quantization for Training CNNs. [__`qnn`__]
- [[AAAI](https://arxiv.org/abs/2009.14502)] Stochastic Precision Ensemble: Self‐Knowledge Distillation for Quantized Deep Neural Networks. [__`qnn`__]
- [AAAI] Optimizing Information Theory Based Bitwise Bottlenecks for Efficient Mixed-Precision Activation Quantization. [__`qnn`__]
- [[AAAI](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=&cad=rja&uact=8&ved=2ahUKEwjD6aPrqbnvAhXeIDQIHWNdDCUQFjADegQIAxAD&url=https%3A%2F%2Fwww.aaai.org%2FAAAI21Papers%2FAAAI-1054.HuP.pdf&usg=AOvVaw2R_BcDlKyuuAPHMeO0Q-1c)] OPQ: Compressing Deep Neural Networks with One-shot Pruning-Quantization. [__`qnn`__]
- [[AAAI](https://arxiv.org/pdf/2012.08185)] Scalable Verification of Quantized Neural Networks. [__`qnn`__]
- [[AAAI]()] Uncertainty Quantification in CNN through the Bootstrap of Convex Neural Networks. [__`qnn`__]
- [[AAAI](https://www.semanticscholar.org/paper/FracBits%3A-Mixed-Precision-Quantization-via-Yang-Jin/cb219432863778fa173925d51fbf02af1d17ad98)] FracBits:  Mixed Precision Quantization via Fractional Bit-Widths. [__`qnn`__]
- [[AAAI](https://arxiv.org/pdf/2002.09049)] Post-­‐training Quantization with Multiple Points: Mixed Precision without Mixed Precision. [__`qnn`__]
- [[AAAI](https://arxiv.org/pdf/1907.05911)] Vector Quantized Bayesian Neural Network Inference for Data Streams. [__`qnn`__]
- [[AAAI](https://www.aaai.org/AAAI21Papers/AAAI-4473.LiY.pdf)] TRQ: Ternary Neural Networks with Residual Quantization. [__`qnn`__]
- [[AAAI](https://arxiv.org/pdf/2010.02577)] Memory and Computation-Efficient Kernel SVM via Binary Embedding and Ternary Coefficients.  [**`bnn`**] 
- [[AAAI](https://arxiv.org/pdf/2010.02778)] Compressing Deep Convolutional Neural Networks by Stacking Low-­Dimensional Binary Convolution Filters.  [**`bnn`**] 
- [[AAAI]()] Training Binary Neural Network without Batch Normalization for Image Super-Resolution.  [**`bnn`**]
- [[AAAI]()] SA-BNN: State-­Aware Binary Neural Network.  [**`bnn`**]
- [[ACL](https://aclanthology.org/2021.findings-acl.363)] On the Distribution, Sparsity, and Inference-time Quantization of Attention Values in Transformers. [__`qnn`__] 
- [[arxiv](https://arxiv.org/abs/1911.07346)] Any-Precision  Deep Neural Networks.  [__`mixed`__] [[torch](https://github.com/SHI-Labs/Any-Precision-DNNs)]
- [[arxiv](http://arxiv.org/abs/2103.12369)] ReCU: Reviving the Dead Weights in Binary Neural Networks.  [**`bnn`**] [[torch](https://github.com/z-hXu/ReCU)]
- [[arxiv](https://arxiv.org/abs/2106.14156)] Post-Training Quantization for Vision Transformer. [**`qnn`**]
- [[arxiv](http://arxiv.org/abs/2103.13630)] A Survey of Quantization Methods for Efficient Neural Network Inference. 
- [[arxiv](https://arxiv.org/pdf/2111.12293.pdf)] PTQ4ViT: Post-Training Quantization Framework for Vision Transformers. [__`qnn`__] 

### 2020

- [[ACL](https://www.aclweb.org/anthology/2020.sustainlp-1.4.pdf)] End to End Binarized Neural Networks for Text Classification. [**`bnn`**] <!--citation 0-->
- [[AAAI](https://aaai.org/ojs/index.php/AAAI/article/view/6035)] HLHLp: Quantized Neural Networks Traing for Reaching Flat Minima in Loss Sufrface. [__`qnn`__] 
- [[AAAI](https://arxiv.org/abs/1909.05840)] [72:fire:] Q-BERT: Hessian Based Ultra Low Precision Quantization of BERT.  [__`qnn`__] 
- [[AAAI](https://aaai.org/ojs/index.php/AAAI/article/view/6900)] Sparsity-Inducing Binarized Neural Networks. [**`bnn`**] 
- [[AAAI](https://aaai.org/ojs/index.php/AAAI/article/view/6134)] Towards Accurate Low Bit-Width Quantization with Multiple Phase Adaptations. 
- [[COOL CHIPS](https://ieeexplore.ieee.org/document/9097642/)] A Novel In-DRAM Accelerator Architecture for Binary Neural Network.  [**`hardware`**]  <!--citation 0-->
- [[CoRR](https://arxiv.org/pdf/2002.10778.pdf)] Training Binary Neural Networks using the Bayesian Learning Rule. [**`bnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2020/papers/Han_GhostNet_More_Features_From_Cheap_Operations_CVPR_2020_paper.pdf)] [47:fire:] GhostNet: More Features from Cheap Operations.  [__`qnn`__] [[tensorflow & torch](https://github.com/huawei-noah/ghostnet)] [1.2k:star:]  <!--citation 47-->
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2020/papers/Qin_Forward_and_Backward_Information_Retention_for_Accurate_Binary_Neural_Networks_CVPR_2020_paper.pdf)] Forward and Backward Information Retention for Accurate Binary Neural Networks. [**`bnn`**] [[torch](https://github.com/htqin/IR-Net)] [105:star:] <!--citation 15-->
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2020/papers/Wang_APQ_Joint_Search_for_Network_Architecture_Pruning_and_Quantization_Policy_CVPR_2020_paper.pdf)] APQ: Joint Search for Network Architecture, Pruning and Quantization Policy. [__`qnn`__] [[torch](https://github.com/mit-han-lab/apq)] [76:star:]
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2020/papers/Wu_Rotation_Consistent_Margin_Loss_for_Efficient_Low-Bit_Face_Recognition_CVPR_2020_paper.pdf)] Rotation Consistent Margin Loss for Efficient Low-Bit Face Recognition. [__`qnn`__] 
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2020/papers/Wang_BiDet_An_Efficient_Binarized_Object_Detector_CVPR_2020_paper.pdf)] BiDet: An Efficient Binarized Object Detector.  [ **`qnn`** ]  [[torch](https://github.com/ZiweiWangTHU/BiDet)] [112:star:] <!--citation 3-->
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2020/papers/Zhang_Fixed-Point_Back-Propagation_Training_CVPR_2020_paper.pdf)] Fixed-Point Back-Propagation Training. [[video](https://www.youtube.com/watch?v=nVRNygIQKI0)] [__`qnn`__]
- [[CVPR](https://openaccess.thecvf.com/content_CVPRW_2020/papers/w40/Yu_Low-Bit_Quantization_Needs_Good_Distribution_CVPRW_2020_paper.pdf)] Low-Bit Quantization Needs Good Distribution.  [**`qnn`**] <!--citation 1-->
- [[DATE](https://ieeexplore.ieee.org/document/9116220)] BNNsplit: Binarized Neural Networks for embedded distributed FPGA-based computing systems. [**`bnn`**] <!--citation 1-->
- [[DATE](https://arxiv.org/abs/1912.04050)] PhoneBit: Efficient GPU-Accelerated Binary Neural Network Inference Engine for Mobile Phones.  [**`bnn`**] [**`hardware`**] 
- [[DATE](https://ieeexplore.ieee.org/abstract/document/9116308)] OrthrusPE: Runtime Reconfigurable Processing Elements for Binary Neural Networks. [**`bnn`**] <!--citation 2-->
- [[ECCV](https://arxiv.org/abs/2002.06963)] Learning Architectures for Binary Networks. [**`bnn`**] [[torch](https://github.com/gistvision/bnas)] <!--citation 5-->
- [[ECCV](https://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123510426.pdf)]PROFIT: A Novel Training Method for sub-4-bit MobileNet Models. [**`qnn`**] <!--citation 2-->
- [[ECCV](https://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123480222.pdf)] ProxyBNN: Learning Binarized Neural Networks via Proxy Matrices. [**`bnn`**] <!--citation 2-->
- [[ECCV](https://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123590137.pdf)] ReActNet: Towards Precise Binary Neural Network with Generalized Activation Functions. [**`bnn`**] [[torch](https://github.com/liuzechun/ReActNet)] [108:star:]  <!--citation 7-->
- [[ECCV](https://arxiv.org/abs/2007.10463)] Differentiable Joint Pruning and Quantization for Hardware Efficiency.  [**`hardware`**] <!--citation 6-->
- [[EMNLP](https://arxiv.org/abs/2009.12812)] TernaryBERT: Distillation-aware Ultra-low Bit BERT. [**`qnn`**] 
- [[EMNLP](https://arxiv.org/abs/1910.10485)] Fully Quantized Transformer for Machine Translation. [**`qnn`**] 
- [[ICET](https://ieeexplore.ieee.org/document/9119704)] An Energy-Efficient Bagged Binary Neural Network Accelerator. [**`bnn`**]  [**`hardware`**]  <!--citation 0-->
- [[ICASSP](https://ieeexplore.ieee.org/document/9054599)] Balanced Binary Neural Networks with Gated Residual. [**`bnn`**]  <!--citation 3-->
- [[ICML](https://proceedings.icml.cc/static/paper_files/icml/2020/181-Paper.pdf)] Training Binary Neural Networks through Learning with Noisy Supervision. [**`bnn`**]  <!--citation 5-->
- [[ICLR](https://xhplus.github.io/publication/conference-paper/iclr2020/dms/DMS.pdf)] DMS: Differentiable Dimension Search for Binary Neural Networks.  [**`bnn`**] 
- [[ICLR]()] [19:fire:] Training Binary Neural Networks with Real-to-Binary Convolutions. [**`bnn`**] [[code is comming](https://github.com/brais-martinez/real2binary)] [[re-implement](https://github.com/larq/zoo/blob/master/larq_zoo/literature/real_to_bin_nets.py)] <!--citation 19-->
- [[ICLR](https://arxiv.org/abs/2002.06517)] BinaryDuo: Reducing Gradient Mismatch in Binary Activation Network by Coupling Binary Activations. [**`bnn`**] [[torch](https://github.com/Hyungjun-K1m/BinaryDuo)] <!--citation 6-->
- [[ICLR](https://openreview.net/forum?id=Hyx0slrFvH)] Mixed Precision DNNs: All You Need is a Good Parametrization. [**`mixed`**] [[code](https://github.com/sony/ai-research-code/tree/master/mixed-precision-dnns)] [73:star:]
- [[IJCV](https://arxiv.org/abs/2009.04247)] Binarized Neural Architecture Search for Efficient Object Recognition. [**`bnn`**] <!--citation 0-->
- [[IJCAI](https://arxiv.org/pdf/2005.00057.pdf)] CP-NAS: Child-Parent Neural Architecture Search for Binary Neural Networks.  [**`bnn`**] 
- [[IJCAI](https://www.ijcai.org/Proceedings/2020/0520.pdf)] Towards Fully 8-bit Integer Inference for the Transformer Model. [**`qnn`**] [**`nlp`**] 
- [[IJCAI](https://www.ijcai.org/proceedings/2020/318)] Soft Threshold Ternary Networks.  [**`qnn`**]
- [[IJCAI](https://www.ijcai.org/proceedings/2020/121)] Overflow Aware Quantization: Accelerating Neural Network Inference by Low-bit Multiply-Accumulate Operations.  [**`qnn`**]
- [[IJCAI](https://www.ijcai.org/proceedings/2020/292)] Direct Quantization for Training Highly Accurate Low Bit-width Deep Neural Networks.  [**`qnn`**] 
- [[IJCAI](https://www.ijcai.org/proceedings/2020/288)] Fully Nested Neural Network for Adaptive Compression and Quantization. [**`qnn`**] 
- [[ISCAS](https://arxiv.org/pdf/2004.08914.pdf)] MuBiNN: Multi-Level Binarized Recurrent Neural Network for EEG Signal Classification. [**`bnn`**] <!--citation 0-->
- [[ISQED](https://ieeexplore.ieee.org/document/9136977)] BNN Pruning: Pruning Binary Neural Network Guided by Weight Flipping Frequency. [**`bnn`**] [[torch](https://github.com/PSCLab-ASU/BNNPruning)] <!--citation 0-->
- [[MICRO](http://arxiv.org/abs/2005.03842)] GOBO: Quantizing Attention-Based NLP Models for Low Latency and Energy Efficient Inference. [**`qnn`**] [**`nlp`**] 
- [[MLST](https://arxiv.org/abs/2003.06308)] Compressing deep neural networks on FPGAs to binary and ternary precision with HLS4ML. [**`hardware`**]  [**`qnn`**] <!--citation 11-->
- [[NeurIPS](https://papers.nips.cc/paper/2020/file/53c5b2affa12eed84dfec9bfd83550b1-Paper.pdf)] Rotated Binary Neural Network. [**`bnn`**] [[torch](https://github.com/lmbxmu/RBNN)]
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/file/2a084e55c87b1ebcdaad1f62fdbbac8e-Paper.pdf)] Searching for Low-Bit Weights in Quantized Neural Networks. [**`qnn`**] [[torch](https://github.com/zhaohui-yang/Binary-Neural-Networks/tree/main/SLB)]  <!--citation 4-->
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/hash/92049debbe566ca5782a3045cf300a3c-Abstract.html)] Universally Quantized Neural Compression.  [**`qnn`**]
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/hash/1385974ed5904a438616ff7bdb3f7439-Abstract.html)] Efficient Exact Verification of Binarized Neural Networks. [**`bnn`**] [[torch](https://github.com/jia-kai/eevbnn)]
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/hash/96fca94df72984fc97ee5095410d4dec-Abstract.html)] Path Sample-Analytic Gradient Estimators for Stochastic Binary Networks. [**`bnn`**] [[code](https://github.com/shekhovt/PSA-Neurips2020)]
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/hash/d77c703536718b95308130ff2e5cf9ee-Abstract.html)] HAWQ-V2: Hessian Aware trace-Weighted Quantization of Neural Networks.  [**`qnn`**] 
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/hash/3f13cf4ddf6fc50c0d39a1d5aeb57dd8-Abstract.html)] Bayesian Bits: Unifying Quantization and Pruning. [**`qnn`**]
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/hash/3948ead63a9f2944218de038d8934305-Abstract.html)] Robust Quantization: One Model to Rule Them All. [**`qnn`**]
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/hash/26ed695e9b7b9f6463ef4bc1fd74fc87-Abstract.html)] Closing the Dequantization Gap: PixelCNN as a Single-Layer Flow. [**`qnn`**] [[torch](https://github.com/didriknielsen/pixelcnn_flow)]
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/hash/20b5e1cf8694af7a3c1ba4a87f073021-Abstract.html)] Adaptive Gradient Quantization for Data-Parallel SGD. [**`qnn`**] [[torch](https://github.com/tabrizian/learning-to-quantize)]
- [[NeurIPS](https://proceedings.neurips.cc/paper/2020/hash/0e230b1a582d76526b7ad7fc62ae937d-Abstract.html)] FleXOR: Trainable Fractional Quantization. [**`qnn`**]
- [[NeurIPS](http://arxiv.org/abs/2005.11035)] Position-based Scaled Gradient for Model Quantization and Pruning.  [**`qnn`**] [[torch](https://github.com/Jangho-Kim/PSG-pytorch)] 
- [[NN](https://www.sciencedirect.com/science/article/abs/pii/S0893608019304290?via%3Dihub)] Training high-performance and large-scale deep neural networks with full 8-bit integers. [**`qnn`**] <!--citation 13-->
- [[Neurocomputing](https://www.sciencedirect.com/science/article/abs/pii/S0925231219314274)] Eye localization based on weight binarization cascade convolution neural network. [**`bnn`**]
- [[PR](https://arxiv.org/abs/2004.03333)] [23:fire:] Binary neural networks: A survey. [**`bnn`**]  <!--citation 23-->
- [[PR Letters](https://arxiv.org/abs/2008.01438)] Controlling information capacity of binary neural network. [**`bnn`**]   <!--citation 0-->
- [[SysML](https://ubicomplab.cs.washington.edu/pdfs/riptide.pdf)] Riptide: Fast End-to-End Binarized Neural Networks. [**`qnn`**]  [[tensorflow](https://github.com/jwfromm/Riptide)] [129:star:] <!--citation 5-->
- [[TPAMI](https://ieeexplore.ieee.org/document/8444745/)] Hierarchical Binary CNNs for Landmark Localization with Limited Resources. [**`bnn`**]  [[homepage](https://www.adrianbulat.com/binary-cnn-landmarks)] [[code](https://github.com/1adrianb/binary-human-pose-estimation)]
- [[TPAMI](https://ieeexplore.ieee.org/document/8573867/)] Deep Neural Network Compression by In-Parallel Pruning-Quantization. 
- [[TPAMI](https://ieeexplore.ieee.org/document/8674614/)] Towards Efficient U-Nets: A Coupled and Quantized Approach. 
- [[TVLSI](https://arxiv.org/pdf/2003.02628.pdf)] Phoenix: A Low-Precision Floating-Point Quantization Oriented Architecture for Convolutional Neural Networks. [**`qnn`**] <!--citation 0-->
- [[WACV](https://openaccess.thecvf.com/content_WACV_2020/papers/Phan_MoBiNet_A_Mobile_Binary_Network_for_Image_Classification_WACV_2020_paper.pdf)] MoBiNet: A Mobile Binary Network for Image Classification. [**`bnn`**] <!--citation 11-->
- [[IEEE Access](https://ieeexplore.ieee.org/document/9091590/)] An Energy-Efficient and High Throughput in-Memory Computing Bit-Cell With Excellent Robustness Under Process Variations for Binary Neural Network. [**`bnn`**]  [**`hardware`**]  <!--citation 0-->
- [[IEEE Trans. Magn](https://arxiv.org/abs/2003.05132)] SIMBA: A Skyrmionic In-Memory Binary Neural Network Accelerator.  [**`bnn`**] <!--citation 0-->
- [[IEEE TCS.II](https://ieeexplore.ieee.org/document/9144282/)] A Resource-Efficient Inference Accelerator for Binary Convolutional Neural Networks.  [**`hardware`**]  <!--citation 1-->
- [[IEEE TCS.I](https://arxiv.org/pdf/2003.12558.pdf)] IMAC: In-Memory Multi-Bit Multiplication and ACcumulation in 6T SRAM Array.  [**`qnn`**] <!--citation 3-->
- [[IEEE Trans. Electron Devices](https://ieeexplore.ieee.org/document/9112690)] Design of High Robustness BNN Inference Accelerator Based on Binary Memristors. [**`bnn`**]  [**`hardware`**] <!--citation 0-->
- [[arxiv](https://arxiv.org/abs/2004.07320)] Training with Quantization Noise for Extreme Model Compression. [**`qnn`**] [[torch](https://github.com/pytorch/fairseq/tree/master/examples/quant_noise)] 
- [[arxiv](https://arxiv.org/pdf/2004.11147.pdf)] Binarized Graph Neural Network. [**`bnn`**] <!--citation 0-->
- [[arxiv](https://arxiv.org/pdf/1909.09139.pdf)] How Does Batch Normalization Help Binary Training? [**`bnn`**] <!--citation 5-->
- [[arxiv](https://arxiv.org/pdf/2007.05223.pdf)] Distillation Guided Residual Learning for Binary Convolutional Neural Networks. [**`bnn`**] <!--citation 1-->
- [[arxiv](https://arxiv.org/abs/2006.16578)] Accelerating Binarized Neural Networks via Bit-Tensor-Cores in Turing GPUs.  [**`bnn`**] [[code](https://github.com/pnnl/TCBNN)] <!--citation 1-->
- [[arxiv](https://arxiv.org/abs/2001.05936)] MeliusNet: Can Binary Neural Networks Achieve MobileNet-level Accuracy?  [**`bnn`**] [[code](https://github.com/hpi-xnor/BMXNet-v2)] [192:star:] <!--citation 13-->
- [[arxiv](https://arxiv.org/pdf/2001.01091.pdf)] RPR: Random Partition Relaxation for Training; Binary and Ternary Weight Neural Networks.  [**`bnn`**] [**`qnn`**] <!--citation 3-->
- [[paper](https://www.researchgate.net/publication/343568789_Towards_Lossless_Binary_Convolutional_Neural_Networks_Using_Piecewise_Approximation)] Towards Lossless Binary Convolutional Neural Networks Using Piecewise Approximation.  [**`bnn`**]  <!--citation 2-->
- [[arxiv](https://arxiv.org/abs/2006.07522)] Understanding Learning Dynamics of Binary Neural Networks via Information Bottleneck. [**`bnn`**] <!--citation 0-->
- [[arxiv](https://arxiv.org/abs/2012.15701)] BinaryBERT: Pushing the Limit of BERT Quantization.  [**`bnn`**] [**`nlp`**]
- [[ECCV](http://arxiv.org/abs/2003.01711)] BATS:  Binary ArchitecTure Search.  [**`bnn`**]

### 2019

- [[AAAI](https://www.aaai.org/ojs/index.php/AAAI/article/view/4273/4151)] Efficient Quantization for Neural Networks with Binary Weights and Low Bitwidth Activations. [**`qnn`**]
- [[AAAI](https://www.aaai.org/ojs/index.php/AAAI/article/view/4848/4721)] [31:fire:]  Projection Convolutional Neural Networks for 1-bit CNNs via Discrete Back Propagation.  [**`bnn`**] 
- [[APCCAS](https://ieeexplore.ieee.org/document/8953134/)] Using Neuroevolved Binary Neural Networks to solve reinforcement learning environments. [**`bnn`**] [[code](https://github.com/rval735/BiSUNA)] 
- [[BMVC](https://arxiv.org/abs/1909.13863)] [32:fire:] XNOR-Net++: Improved Binary Neural Networks. [**`bnn`**]
- [[BMVC](https://arxiv.org/abs/1909.11366)] Accurate and Compact Convolutional Neural Networks with Trained Binarization.  [**`bnn`**] 
- [[CoRR](https://arxiv.org/abs/1908.07748)] RBCN: Rectified Binary Convolutional Networks for Enhancing the Performance of 1-bit DCNNs.  [**`bnn`**] 
- [[CoRR](https://arxiv.org/abs/1912.10103)] TentacleNet: A Pseudo-Ensemble Template for Accurate Binary Convolutional Neural Networks. [**`bnn`**]
- [[CoRR](http://arxiv.org/abs/1904.05868)] Improved training of binary networks for human pose estimation and image recognition. [**`bnn`**] 
- [[CoRR](https://arxiv.org/abs/1911.10862)] Binarized Neural Architecture Search. [**`bnn`**]
- [[CoRR](https://arxiv.org/pdf/1904.07852.pdf)] Matrix and tensor decompositions for training binary neural networks.  [**`bnn`**] 
- [[CoRR](https://arxiv.org/pdf/1906.08637.pdf)] Back to Simplicity: How to Train Accurate BNNs from Scratch?  [**`bnn`**] [[code](https://github.com/hpi-xnor/BMXNet-v2)] [193:star:]
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Zhuang_Structured_Binary_Neural_Networks_for_Accurate_Image_Classification_and_Semantic_CVPR_2019_paper.pdf)] [53:fire:] Structured Binary Neural Networks for Accurate Image Classification and Semantic Segmentation. [**`bnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Cao_SeerNet_Predicting_Convolutional_Neural_Network_Feature-Map_Sparsity_Through_Low-Bit_Quantization_CVPR_2019_paper.pdf)] SeerNet: Predicting Convolutional Neural Network Feature-Map Sparsity Through Low-Bit Quantization. [**`qnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Wang_HAQ_Hardware-Aware_Automated_Quantization_With_Mixed_Precision_CVPR_2019_paper.pdf)] [218:fire:] HAQ: Hardware-Aware Automated Quantization with Mixed Precision. [**`qnn`**] [**`hardware`**] [[torch](https://github.com/mit-han-lab/haq)] [233:star:]
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Yang_Quantization_Networks_CVPR_2019_paper.pdf)] [48:fire:]  Quantization Networks.  [**`bnn`**] [[torch](https://github.com/aliyun/alibabacloud-quantization-networks)] [82:star:]
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Li_Fully_Quantized_Network_for_Object_Detection_CVPR_2019_paper.pdf)] Fully Quantized Network for Object Detection. [**`qnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Wang_Learning_Channel-Wise_Interactions_for_Binary_Convolutional_Neural_Networks_CVPR_2019_paper.pdf)] Learning Channel-Wise Interactions for Binary Convolutional Neural Networks. [**`bnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Liu_Circulant_Binary_Convolutional_Networks_Enhancing_the_Performance_of_1-Bit_DCNNs_CVPR_2019_paper.pdf)] [31:fire:] Circulant Binary Convolutional Networks: Enhancing the Performance of 1-bit DCNNs with Circulant Back Propagation. [**`bnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Ding_Regularizing_Activation_Distribution_for_Training_Binarized_Deep_Networks_CVPR_2019_paper.pdf)] [36:fire:] Regularizing Activation Distribution for Training Binarized Deep Networks.  [**`bnn`**]  
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Xu_A_MainSubsidiary_Network_Framework_for_Simplifying_Binary_Neural_Networks_CVPR_2019_paper.pdf)] A Main/Subsidiary Network Framework for Simplifying Binary Neural Network. [**`bnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_CVPR_2019/papers/Zhu_Binary_Ensemble_Neural_Network_More_Bits_per_Network_or_More_CVPR_2019_paper.pdf)] Binary Ensemble Neural Network: More Bits per Network or More Networks per Bit? [**`bnn`**] 
- [[FPGA](https://arxiv.org/abs/1810.02068)] Towards Fast and Energy-Efficient Binarized Neural Network Inference on FPGA.  [**`bnn`**]  [**`hardware`**] 
- [[GLSVLSI](https://dl.acm.org/doi/pdf/10.1145/3299874.3318034)] Binarized Depthwise Separable Neural Network for Object Tracking in FPGA.  [**`bnn`**]  [**`hardware`**]
- [[ICCV](https://arxiv.org/abs/1908.05033)] [55:fire:] Differentiable Soft Quantization: Bridging Full-Precision and Low-Bit Neural Networks. [**`qnn`**]  
- [[ICCV](https://arxiv.org/pdf/1908.06314.pdf)] Bayesian optimized 1-bit cnns.  [**`bnn`**]
- [[ICCV](https://openaccess.thecvf.com/content_ICCVW_2019/papers/NeurArch/Shen_Searching_for_Accurate_Binary_Neural_Architectures_ICCVW_2019_paper.pdf)] Searching for Accurate Binary Neural Architectures. [**`bnn`**] 
- [[ICCV](https://openaccess.thecvf.com/content_ICCV_2019/html/Nagel_Data-Free_Quantization_Through_Weight_Equalization_and_Bias_Correction_ICCV_2019_paper.html)] Data-Free Quantization Through Weight Equalization and Bias Correction.  [**`qnn`**]  [**`hardware`**] [[torch](https://github.com/jakc4103/DFQ)]
- [[ICML](https://arxiv.org/abs/1906.00532v2)] Efficient 8-Bit Quantization of Transformer Neural Machine Language Translation Model.  [**`qnn`**] [**`nlp`**]
- [[ICLR](https://openreview.net/pdf?id=HyzMyhCcK7)] [37:fire:] ProxQuant: Quantized Neural Networks via Proximal Operators.  [**`qnn`**] [[torch](https://github.com/allenbai01/ProxQuant)] 
- [[ICLR](https://openreview.net/pdf?id=rJfUCoR5KX)] An Empirical study of Binary Neural Networks' Optimisation.  [**`bnn`**]  
- [[ICIP](https://ieeexplore.ieee.org/document/8802610)] Training Accurate Binary Neural Networks from Scratch.  [**`bnn`**] [[code](https://github.com/hpi-xnor/BMXNet-v2)] [192:star:]
- [[ICUS](https://ieeexplore.ieee.org/document/8996039/)] Balanced Circulant Binary Convolutional Networks. [**`bnn`**] 
- [[IJCAI](https://see.xidian.edu.cn/faculty/chdeng/Welcome%20to%20Cheng%20Deng's%20Homepage_files/Papers/Conference/IJCAI2019_Feng.pdf)] Binarized Neural Networks for Resource-Efficient Hashing with Minimizing Quantization Loss. [**`bnn`**]
- [[IJCAI](https://www.ijcai.org/Proceedings/2019/0667.pdf)] Binarized Collaborative Filtering with Distilling Graph Convolutional Network.  [**`bnn`**]
- [[ISOCC](https://ieeexplore.ieee.org/document/9027649)] Dual Path Binary Neural Network.  [**`bnn`**] 
- [[IEEE J. Emerg. Sel. Topics Circuits Syst.](https://ieeexplore.ieee.org/document/8668446/)] Hyperdrive: A Multi-Chip Systolically Scalable Binary-Weight CNN Inference Engine.  [**`hardware`**] 
- [[IEEE JETC](https://arxiv.org/pdf/1807.07928.pdf)] [128:fire:] Eyeriss v2: A Flexible Accelerator for Emerging Deep Neural Networks on Mobile Devices. [**`hardware`**]  
- [[IEEE J. Solid-State Circuits](https://ieeexplore.ieee.org/document/8581485)] An Energy-Efficient Reconfigurable Processor for Binary-and Ternary-Weight Neural Networks With Flexible Data Bit Width. [**`qnn`**]
- [[MDPI Electronics](https://doi.org/10.3390/electronics8060661)] A Review of Binarized Neural Networks.  [**`bnn`**] 
- [[NeurIPS](https://csyhhu.github.io/data/MetaQuant.pdf)] MetaQuant: Learning to Quantize by Learning to Penetrate Non-differentiable Quantization. [**`qnn`**] [[torch](https://github.com/csyhhu/MetaQuant)]
- [[NeurIPS](https://papers.nips.cc/paper/2019/file/9ca8c9b0996bbf05ae7753d34667a6fd-Paper.pdf)] Latent Weights Do Not Exist: Rethinking Binarized Neural Network Optimization.  [**`bnn`**] [[tensorflow](https://github.com/plumerai/rethinking-bnn-optimization)] 
- [[NeurIPS](http://arxiv.org/abs/1812.11800)] [43:fire:]  Regularized Binary Network Training. [**`bnn`**] 
- [[NeurIPS](https://www.emc2-ai.org/assets/docs/neurips-19/emc2-neurips19-paper-31.pdf)] [44:fire:] Q8BERT: Quantized 8Bit BERT.  [**`qnn`**] [**`nlp`**] 
- [[NeurIPS](https://www.emc2-ai.org/assets/docs/neurips-19/emc2-neurips19-paper-36.pdf)] Fully Quantized Transformer for Improved Translation.  [**`qnn`**] [**`nlp`**] 
- [[NeurIPS](https://openreview.net/pdf?id=rJgB34rx8r)] Normalization Helps Training of Quantized LSTM. [**`qnn`**] [**`bnn`**]  
- [[RoEduNet](https://ieeexplore.ieee.org/document/8909493/)] PXNOR: Perturbative Binary Neural Network.  [**`bnn`**] [[code](https://github.com/Apfelin/PXNOR)] 
- [[SiPS](https://arxiv.org/abs/1909.01688)] Knowledge distillation for optimization of quantized deep neural networks. [**`qnn`**]  
- [[TMM](https://arxiv.org/abs/1708.05127)] [45:fire:] Deep Binary Reconstruction for Cross-Modal Hashing. [**`bnn`**] 
- [[TMM](https://arxiv.org/pdf/1712.02956.pdf)] Compact Hash Code Learning With Binary Deep Neural Network.  [**`bnn`**] 
- [[IEEE TCS.I](https://arxiv.org/pdf/1807.00343.pdf)] Xcel-RAM: Accelerating Binary Neural Networks in High-Throughput SRAM Compute Arrays.  [**`hardware`**]
- [[IEEE TCS.I](https://ieeexplore.ieee.org/abstract/document/8643565)] Recursive Binary Neural Network Training Model for Efficient Usage of On-Chip Memory. [**`bnn`**] 
- [[VLSI-SoC](https://ieeexplore.ieee.org/document/8920343/)] A Product Engine for Energy-Efficient Execution of Binary Neural Networks Using Resistive Memories.  [**`bnn`**]  [**`hardware`**]
- [[paper](https://openreview.net/pdf?id=SJfHg2A5tQ)] [43:fire:]  BNN+: Improved Binary Network Training. [**`bnn`**] 
- [[arxiv](http://arxiv.org/abs/1902.00730)] Self-Binarizing Networks.  [**`bnn`**] 
- [[arxiv](https://arxiv.org/abs/1912.12607)] Towards Unified INT8 Training for Convolutional Neural Network. [**`qnn`**]  
- [[arxiv](http://arxiv.org/abs/1908.05858)] daBNN: A Super Fast Inference Framework for Binary Neural Networks on ARM devices.  [**`bnn`**] [**`hardware`**] [[code](https://github.com/JDAI-CV/dabnn)]
- [[arxiv](https://arxiv.org/abs/1911.12491)] QKD: Quantization-aware Knowledge Distillation.  [**`qnn`**]  
- [[arxiv](https://arxiv.org/abs/1812.00090)] [59:fire:] Mixed Precision Quantization of ConvNets via Differentiable Neural Architecture Search. [**`qnn`**]  

### 2018

- [[AAAI](https://arxiv.org/abs/1802.02733)] From Hashing to CNNs: Training BinaryWeight Networks via Hashing.  [**`bnn`**] 
- [[AAAI](https://aaai.org/ocs/index.php/AAAI/AAAI18/paper/viewPDFInterstitial/16767/16728)] [136:fire:] Extremely Low Bit Neural Network: Squeeze the Last Bit Out with ADMM.  [**`qnn`**] [[homepage](https://web.stanford.edu/~boyd/admm.html)] 
- [[CAAI](https://ieeexplore.ieee.org/stamp/stamp.jsp?arnumber=8603080)] Fast object detection based on binary deep convolution neural networks. [**`bnn`**] 
- [[CoRR](https://arxiv.org/abs/1802.02178)] LightNN: Filling the Gap between Conventional Deep Neural Networks and Binarized Networks. [**`bnn`**] 
- [[CoRR](https://arxiv.org/pdf/1801.06313.pdf)] BinaryRelax: A Relaxation Approach For Training Deep Neural Networks With Quantized Weights. [**`bnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_cvpr_2018/papers/Wang_Two-Step_Quantization_for_CVPR_2018_paper.pdf)] [63:fire:] Two-Step Quantization for Low-bit Neural Networks. [**`qnn`**]  
- [[CVPR](https://arxiv.org/abs/1908.04680)] Effective Training of Convolutional Neural Networks with Low-bitwidth Weights and Activations. [**`qnn`**]
- [[CVPR](https://openaccess.thecvf.com/content_cvpr_2018/papers/Zhuang_Towards_Effective_Low-Bitwidth_CVPR_2018_paper.pdf)] [97:fire:] Towards Effective Low-bitwidth Convolutional Neural Networks. [**`qnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_cvpr_2018/papers/Wang_Modulated_Convolutional_Networks_CVPR_2018_paper.pdf)] Modulated convolutional networks. [**`bnn`**] 
- [[CVPR](https://openaccess.thecvf.com/content_cvpr_2018/papers/Faraone_SYQ_Learning_Symmetric_CVPR_2018_paper.pdf)] [67:fire:] SYQ: Learning Symmetric Quantization For Efficient Deep Neural Networks. [**`qnn`**] [[code](https://www.github.com/julianfaraone/SYQ)] 
- [[CVPR](https://openaccess.thecvf.com/content_cvpr_2018/papers/Jacob_Quantization_and_Training_CVPR_2018_paper.pdf)] [630:fire:] Quantization and Training of Neural Networks for Efficient Integer-Arithmetic-Only Inference. [**`qnn`**] 
- [[ECCV](https://www.ecva.net/papers/eccv_2018/papers_ECCV/papers/Qinghao_Hu_Training_Binary_Weight_ECCV_2018_paper.pdf)] Training Binary Weight Networks via Semi-Binary Decomposition. [**`bnn`**] 
- [[ECCV](https://openaccess.thecvf.com/content_ECCV_2018/papers/Diwen_Wan_TBN_Convolutional_Neural_ECCV_2018_paper.pdf)] [47:fire:] TBN: Convolutional Neural Network with Ternary Inputs and Binary Weights. [**`bnn`**] [**`qnn`**] [[torch](https://github.com/dnvtmf/TBN)] 
- [[ECCV](https://openaccess.thecvf.com/content_ECCV_2018/papers/Dongqing_Zhang_Optimized_Quantization_for_ECCV_2018_paper.pdf)] [202:fire:] LQ-Nets: Learned Quantization for Highly Accurate and Compact Deep Neural Networks. [**`qnn`**] [[tensorflow](https://github.com/microsoft/LQ-Nets)] [188:star:] 
- [[ECCV](https://openaccess.thecvf.com/content_ECCV_2018/papers/zechun_liu_Bi-Real_Net_Enhancing_ECCV_2018_paper.pdf)] [145:fire:] Bi-Real Net: Enhancing the Performance of 1-bit CNNs With Improved Representational Capability and Advanced Training Algorithm. [**`bnn`**] [[torch](https://github.com/liuzechun/Bi-Real-net)] [120:star:]
- [[FCCM](http://aceslab.org/sites/default/files/FCCM_2018_resbinnet.pdf)] ReBNet: Residual Binarized Neural Network. [**`bnn`**] [[tensorflow](https://github.com/mohaghasemzadeh/ReBNet)] 
- [[FPL](https://ieeexplore.ieee.org/document/8532584/)] FBNA: A Fully Binarized Neural Network Accelerator. [**`hardware`**]
- [[ICLR](https://arxiv.org/abs/1802.08635)] [65:fire:] Loss-aware Weight Quantization of Deep Networks. [**`qnn`**] [[code](https://github.com/houlu369/Loss-aware-weight-quantization)]   
- [[ICLR](https://research-explorer.app.ist.ac.at/download/7812/7894/2018_ICLR_Polino.pdf)] [230:fire:] Model compression via distillation and quantization. [**`qnn`**]  [[torch](https://github.com/antspy/quantized_distillation)] [284:star:] 
- [[ICLR](https://openreview.net/pdf?id=By5ugjyCb)] [201:fire:]  PACT: Parameterized Clipping Activation for Quantized Neural Networks.  [**`qnn`**] 
- [[ICLR](https://openreview.net/pdf?id=B1ZvaaeAZ)] [168:fire:] WRPN: Wide Reduced-Precision Networks. [**`qnn`**] 
- [[ICLR](https://openreview.net/pdf?id=ryM_IoAqYX)] Analysis of Quantized Models.  [**`qnn`**] 
- [[ICLR](https://openreview.net/pdf?id=B1ae1lZRb)] [141:fire:] Apprentice: Using Knowledge Distillation Techniques To Improve Low-Precision Network Accuracy.  [**`qnn`**]
- [[IJCAI](https://www.ijcai.org/Proceedings/2018/0380.pdf)] Deterministic Binary Filters for Convolutional Neural Networks. [**`bnn`**] 
- [[IJCAI](https://www.ijcai.org/Proceedings/2018/0669.pdf)] Planning in Factored State and Action Spaces with Learned Binarized Neural Network Transition Models.  [**`bnn`**] <!--citation 14-->
- [[IJCNN](https://ieeexplore.ieee.org/document/8489259)] Analysis and Implementation of Simple Dynamic Binary Neural Networks. [**`bnn`**] 
- [[IPDPS](https://ieeexplore.ieee.org/document/8425178)] BitFlow: Exploiting Vector Parallelism for Binary Neural Networks on CPU. [**`bnn`**] 
- [[IEEE J. Solid-State Circuits](http://ieeexplore.ieee.org/document/8226999/)] [66:fire:] BRein Memory: A Single-Chip Binary/Ternary Reconfigurable in-Memory Deep Neural Network Accelerator Achieving 1.4 TOPS at 0.6 W.  [**`hardware`**] [**`qnn`**] 
- [[NCA](https://arxiv.org/pdf/1712.08934.pdf)] [88:fire:] A survey of FPGA-based accelerators for convolutional neural networks. [**`hardware`**] 
- [[NeurIPS](https://papers.nips.cc/paper/2018/file/335d3d1cd7ef05ec77714a215134914c-Paper.pdf)] [150:fire:] Training Deep Neural Networks with 8-bit Floating Point Numbers. [**`qnn`**] 
- [[NeurIPS](https://papers.nips.cc/paper/2018/file/e82c4b19b8151ddc25d4d93baf7b908f-Paper.pdf)] [91:fire:] Scalable methods for 8-bit training of neural networks.  [**`qnn`**]  [[torch](https://github.com/eladhoffer/quantized.pytorch)]  
- [[MM](https://dl.acm.org/doi/10.1145/3240508.3240673)] BitStream: Efficient Computing Architecture for Real-Time Low-Power Inference of Binary Neural Networks on CPUs.  [**`bnn`**]  
- [[Res Math Sci](https://arxiv.org/abs/1808.05240)] Blended coarse gradient descent for full quantization of deep neural networks. [**`qnn`**] [**`bnn`**] 
- [[TCAD](https://ieeexplore.ieee.org/document/8412533/)] XNOR Neural Engine: A Hardware Accelerator IP for 21.6-fJ/op Binary Neural Network Inference. [**`hardware`**] 
- [[TRETS](http://arxiv.org/abs/1809.04570)] [50:fire:] FINN-R: An End-to-End Deep-Learning Framework for Fast Exploration of Quantized Neural Networks.  [**`qnn`**] 
- [[TVLSI](http://ieeexplore.ieee.org/document/8103902/)] An Energy-Efficient Architecture for Binary Weight Convolutional Neural Networks. [**`bnn`**] 
- [[arxiv](https://arxiv.org/abs/1812.01965)] Training Competitive Binary Neural Networks from Scratch. [**`bnn`**] [[code](https://github.com/hpi-xnor/BMXNet-v2)] [192:star:] 
- [[arxiv](https://arxiv.org/abs/1811.09426)] Joint Neural Architecture Search and Quantization.  [**`qnn`**] [[torch](https://github.com/yukang2017/NAS-quantization)] 
- [[CVPR](https://openaccess.thecvf.com/content_cvpr_2018/html/Zhou_Explicit_Loss-Error-Aware_Quantization_CVPR_2018_paper.html)] Explicit loss-error-aware quantization for low-bit deep neural networks. [**`qnn`**]

### 2017

- [[CoRR](https://arxiv.org/pdf/1705.09864.pdf)] BMXNet: An Open-Source Binary Neural Network Implementation Based on MXNet.  [**`bnn`**]  [[code](https://github.com/hpi-xnor)] 
- [[CVPR](https://openaccess.thecvf.com/content_cvpr_2017/papers/Cai_Deep_Learning_With_CVPR_2017_paper.pdf)] [251:fire:] Deep Learning with Low Precision by Half-wave Gaussian Quantization. [**`qnn`**] [[code](https://github.com/zhaoweicai/hwgq)] [118:star:] 
- [[CVPR](https://openaccess.thecvf.com/content_cvpr_2017/papers/Juefei-Xu_Local_Binary_Convolutional_CVPR_2017_paper.pdf)] [156:fire:] Local Binary Convolutional Neural Networks. [**`bnn`**] [[torch](https://github.com/juefeix/lbcnn.torch)] [94:star:] 
- [[FPGA](https://arxiv.org/abs/1612.07119)] [463:fire:] FINN: A Framework for Fast, Scalable Binarized Neural Network Inference. [**`hardware`**] [**`bnn`**] 
- [[ICASSP](https://arxiv.org/abs/1702.08171))] Fixed-point optimization of deep neural networks with adaptive step size retraining. [**`qnn`**]
- [[ICCV](https://openaccess.thecvf.com/content_ICCV_2017/papers/Bulat_Binarized_Convolutional_Landmark_ICCV_2017_paper.pdf)] [130:fire:] Binarized Convolutional Landmark Localizers for Human Pose Estimation and Face Alignment with Limited Resources.  [**`bnn`**] [[homepage](https://www.adrianbulat.com/binary-cnn-landmarks)] [[torch](https://github.com/1adrianb/binary-human-pose-estimation)] [207:star:]
- [[ICCV](https://openaccess.thecvf.com/content_ICCV_2017/papers/Li_Performance_Guaranteed_Network_ICCV_2017_paper.pdf)] [55:fire:] Performance Guaranteed Network Acceleration via High-Order Residual Quantization.  [**`qnn`**] 
- [[ICLR](https://openreview.net/pdf?id=HyQJ-mclg)] [554:fire:] Incremental Network Quantization: Towards Lossless CNNs with Low-Precision Weights. [**`qnn`**] [[torch](https://github.com/Mxbonn/INQ-pytorch)] [144:star:] 
- [[ICLR](https://openreview.net/pdf?id=S1oWlN9ll)] [119:fire:] Loss-aware Binarization of Deep Networks. [**`bnn`**] [[code](https://github.com/houlu369/Loss-aware-Binarization)]  
- [[ICLR](https://openreview.net/pdf?id=HJGwcKclx)] [222:fire:] Soft Weight-Sharing for Neural Network Compression. [__`other`__] 
- [[ICLR](https://openreview.net/pdf?id=S1_pAu9xl)] [637:fire:] Trained Ternary Quantization. [**`qnn`**] [[torch](https://github.com/TropComplique/trained-ternary-quantization)] [90:star:] 
- [[InterSpeech](https://www.isca-speech.org/archive/Interspeech_2017/pdfs/1343.PDF)] Binary Deep Neural Networks for Speech Recognition.  [**`bnn`**]
- [[IPDPSW](https://ieeexplore.ieee.org/document/7965031)] On-Chip Memory Based Binarized Convolutional Deep Neural Network Applying Batch Normalization Free Technique on an FPGA. [**`hardware`**] 
- [[JETC](https://arxiv.org/abs/1702.06392)] A GPU-Outperforming FPGA Accelerator Architecture for Binary Convolutional Neural Networks. [**`hardware`**] [**`bnn`**] 
- [[NeurIPS](https://arxiv.org/abs/1711.11294)] [293:fire:] Towards Accurate Binary Convolutional Neural Network.  [**`bnn`**] [[tensorflow](https://github.com/layog/Accurate-Binary-Convolution-Network)] 
- [[Neurocomputing](http://www.doc.ic.ac.uk/~wl/papers/17/neuro17sl0.pdf)] [126:fire:] FP-BNN: Binarized neural network on FPGA. [**`hardware`**] 
- [[MWSCAS](http://ieeexplore.ieee.org/document/8052915/)] Deep learning binary neural network on an FPGA. [**`hardware`**] [**`bnn`**] 
- [[arxiv](https://arxiv.org/pdf/1705.01462.pdf)] [71:fire:] Ternary Neural Networks with Fine-Grained Quantization. [**`qnn`**]
- [[arxiv](https://arxiv.org/abs/1706.02393)] ShiftCNN: Generalized Low-Precision Architecture for Inference of Convolutional Neural Networks. [**`qnn`**] [[code](https://github.com/gudovskiy/ShiftCNN)] [53:star:] 

### 2016

- [[CoRR](http://arxiv.org/abs/1606.06160)] [1k:fire:] DoReFa-Net: Training Low Bitwidth Convolutional Neural Networks with Low Bitwidth Gradients. [**`qnn`**] [[code](https://github.com/tensorpack/tensorpack/tree/master/examples/DoReFa-Net)] [5.8k:star:] 
- [[ECCV](https://arxiv.org/abs/1603.05279)] [2.7k:fire:] XNOR-Net: ImageNet Classification Using Binary Convolutional Neural Networks. [**`bnn`**] [[torch](https://github.com/allenai/XNOR-Net)] [787:star:] 
- [[ICASSP](https://arxiv.org/abs/1512.01322))] Fixed-point Performance Analysis of Recurrent Neural Networks. [**`qnn`**]
- [[NeurIPS](https://arxiv.org/pdf/1605.04711.pdf)] [572:fire:] Ternary weight networks.  [**`qnn`**] [[code](https://github.com/fengfu-chris/caffe-twns)] [61:star:] 
- [[NeurIPS](https://arxiv.org/pdf/1602.02830))] [1.7k:fire:] Binarized Neural Networks: Training Deep Neural Networks with Weights and Activations Constrained to +1 or -1. [**`bnn`**] [[torch](https://github.com/itayhubara/BinaryNet)] [239:star:] 
- [[CVPR](https://openaccess.thecvf.com/content_cvpr_2016/html/Wu_Quantized_Convolutional_Neural_CVPR_2016_paper.html)] [270:fire:] Quantized convolutional neural networks for mobile devices. [code](https://github.com/jiaxiang-wu/quantized-cnn)

### 2015

- [[ICML](https://arxiv.org/abs/1601.06071)] [191:fire:] Bitwise Neural Networks. [**`bnn`**] 
- [[NeurIPS](https://arxiv.org/abs/1511.00363)] [1.8k:fire:] BinaryConnect: Training Deep Neural Networks with binary weights during propagations. [**`bnn`**] [[code](https://github.com/MatthieuCourbariaux/BinaryConnect)] [330:star:] 
- [[arxiv](https://arxiv.org/abs/1511.06488)] Resiliency of Deep Neural Networks under quantizations. [**`qnn`**] 

## Codes\_and\_Docs

- [[Doc](https://support.alpha-data.com/pub/appnotes/cnn/ad-an-0055_v1_0.pdf)] ZF-Net: An Open Source FPGA CNN Library.

- [[Doc](https://hal.archives-ouvertes.fr/hal-01695375v2/document)] Accelerating CNN inference on FPGAs: A Survey.

- [[中文](https://github.com/Ewenwan/MVision/tree/master/CNN/Deep_Compression/)] An Overview of Deep Compression Approaches.

- [[中文](https://mp.weixin.qq.com/s/RsZCTqCKwpnjATUFC8da7g)] 嵌入式深度学习之神经网络二值化 - FPGA实现

## Our_Team

Our team is part of the DIG group of the State Key Laboratory of Software Development Environment ([SKLSDE](https://ev.buaa.edu.cn/info/1035/1862.htm)), supervised Prof. [Xianglong Liu](https://xlliu-beihang.github.io/). The main research goals of our team is compressing and accelerating models under multiple scenes.

### Current Members

[**Haotong Qin**](https://htqin.github.io/)

* Haotong Qin is a Ph.D. student in the State Key Laboratory of Software Development Environment (SKLSDE) and Shen Yuan Honors College at Beihang University, supervised by Prof. [Wei Li](https://en.wikipedia.org/wiki/Li_Wei_(computer_scientist)) and Prof. [Xianglong Liu](https://xlliu-beihang.github.io/). And He is also a student researcher in Bytedance AI Lab. He obtained a B.Eng degree in computer science and engineering from Beihang University, and interned at the MSRA and Tencent WXG. I'm interested in hardware-friendly deep learning and neural network quantization. And his research goal is to enable state-of-the-art neural network models to be deployed on resource-limited hardware, which includes the compression and acceleration for multiple architectures, and the flexible and efficient deployment on multiple hardware.

**[Ruihao Gong](https://xhplus.github.io/)**

* Ruihao Gong is currently a Ph.D. student in in the State Key Laboratory of Software Development Environment (SKLSDE) and a Senior Research Manager at SenseTime. Since 2017, he worked on the build-up of computer vision systems and model quantization as an intern at Sensetime Research, where he enjoyed working with the talented researchers and grew up a lot with the help of [Fengwei Yu](http://forwil.xyz/), [Wei Wu](https://wuwei-ai.org/), [Jing Shao](https://amandajshao.github.io/), and [Junjie Yan](https://yan-junjie.github.io/). During the early time of the internship, he independently took responsibility for the development of intelligent video analysis system Sensevideo. Later, he started the research on model quantization which can speed up the inference and even the training of neural networks on edge devices. Now he is devoted to further promoting the accuracy of extremely low-bit models and the auto-deployment of quantized models.

**[Yifu Ding](https://yifu-ding.github.io/)**

* Yifu Ding is a senior student in the School of Computer Science and Engineering at Beihang University. She is in the State Key Laboratory of Software Development Environment ([SKLSDE](https://ev.buaa.edu.cn/info/1035/1862.htm)), under the supervision of Prof. [Xianglong Liu](https://xlliu-beihang.github.io/). Currently, she is interested in computer vision and model quantization. She thinks that neural network models which are highly compressed can be deployed on resource-constrained devices. And among all the compression methods, quantization is a potential one.

**Xiuying Wei**

* Xiuying Wei is a first-year graduate student at Beihang University under the supervision of Prof. [Xianglong Liu](https://xlliu-beihang.github.io/). She recevied a bachelor’s degree from Shandong University in 2020. Currently, she is interested in model quantization. She thinks that quantization could make model faster and more robust, which could put deep learning systems on low-power devices and bring more opportunity for future.

**Qinghua Yan**

* I am a senior student in the Sino-French Engineer School at [Beihang University](https://www.buaa.edu.cn/). I just started the research on model compression in the Skate Key Laboratory of Software Development Environment ([SKLSDE](http://www.nlsde.buaa.edu.cn/)), under the supervision of Prof. [Xianglong Liu](http://sites.nlsde.buaa.edu.cn/~xlliu/). I have great enthusiasm for deep learning and model quantization and I really enjoy working with my talented teammates.

**Hong Chen**

* Hong Chen is a first-year graduate student at Beihang University under the supervision of Prof. [Xianglong Liu](https://xlliu-beihang.github.io/). He recevied a bachelor’s degree from Beihang University in 2022. Currently, he is interested in model quantization, especially data-free quantization. He believes that data-free quantization is the general trend, and is committed to breaking through its accuracy bottleneck.

**Aoyu Li**

* I am a senior student in the School of Computer Science and Engineering at Beihang University. Supervised by Prof. Xianglong Liu, I am currently conducting research on model quantization. My research interests are mainly about model compression, deployment and AI systems.

**Xudong Ma**

* Xudong Ma is a first-year graduate student at the School of Computer Science and Engineering, Beihang University. He received his bachelor's degree from UESTC in 2022. He is interested in the direction of model quantization, and he believes that model quantization is one of the current trends in AI.

**Zeyi Sun**

* I am a senior student in Shen Yuan Honors College at Beihang University. I am  currently starting research on model compression, especially knowledge distillation. I believe deploying more and more ML model onto real devices is how we break the last rocky stone on the way to AGI(Artificial General Intelligence). 

**Yuxuan Wen**

* 

### Alumnus

**Mingzhu Shen** 

* Sensetime Research.

**Xiangguo Zhang** 

* Sensetime Research. Xiangguo Zhang achieved the master degree in the School of Computer Science of Beihang University, under the guidance of Prof. [Xianglong Liu](http://sites.nlsde.buaa.edu.cn/~xlliu/). He received a bachelor's degree from Shandong University in 2019 and entered Beihang University in the same year. Currently, he is interested in computer vision and post training quantization.

### Publications

* Haotong Qin*, Xudong Ma*, Yifu Ding*, Xiaoyang Li, Yang Zhang, Yao Tian, Zejun Ma, Jie Luo, Xianglong Liu#. [BiFSMN: Binary Neural Network for Keyword Spotting](https://arxiv.org/abs/2202.06483). **International Joint Conference on Artificial Intelligence (IJCAI)*, 2022.

* Haotong Qin*, Yifu Ding*, Mingyuan Zhang*, Qinghua Yan, Aishan Liu, Qingqing Dang, Ziwei Liu, Xianglong Liu#. [BiBERT: Accurate Fully Binarized BERT](https://openreview.net/forum?id=5xEgrl_5FAJ). **International Conference on Learning Representations (ICLR)*, 2022.

* Xiuying Wei*, Ruihao Gong*, Yuhang Li, Xianglong Liu#, Fengwei Yu. [QDrop: Randomly Dropping Quantization for Extremely Low-bit Post-Training Quantization](https://openreview.net/forum?id=ySQH0oDyp7). **International Conference on Learning Representations (ICLR)*, 2022.

* Xiangguo Zhang*, Haotong Qin\*, Yifu Ding, Ruihao Gong, Qinghua Yan, Renshuai Tao, Yuhang Li, Fengwei Yu, Xianglong Liu#. [Diversifying Sample Generation for Data-Free Quantization](https://arxiv.org/abs/2103.01049). *IEEE Conference on Computer Vision and Pattern Recognition (CVPR)*, 2021 (oral).

* Haotong Qin\*, Zhongang Cai\*, Mingyuan Zhang\*, Yifu Ding, Haiyu Zhao, Shuai Yi, Xianglong Liu#, Hao Su. [BiPointNet: Binary Neural Network for Point Clouds](https://arxiv.org/abs/2010.05501). *International Conference on Learning Representations (ICLR)*, 2021.
- Haotong Qin, Ruihao Gong, Xianglong Liu#, Xiao Bai, Jingkuan Song, Nicu Sebe. [Binary Neural Network: A Survey](https://htqin.github.io/Pubs/pr2020_BNN_survey.pdf). *Pattern Recognition (PR)*, 2020.

- Haotong Qin, Ruihao Gong, Xianglong Liu#, Mingzhu Shen, Ziran Wei, Fengwei Yu, Jingkuan Song. [Forward and Backward Information Retention for Accurate Binary Neural Networks](https://arxiv.org/abs/1909.10788). *IEEE Conference on Computer Vision and Pattern Recognition (CVPR)*, 2020.

- Y. Wu, X. Liu\#, H. Qin , K. Xia, S. Hu, Y. Ma, M. Wang. [Boosting Temporal Binary Coding for Large-scale Video Search](https://www.researchgate.net/publication/339823422_Boosting_Temporal_Binary_Coding_for_Large-scale_Video_Search). *IEEE Transactions on Multimedia (TMM)*, 2020.

- F. Zhu, R. Gong, F. Yu, X. Liu#, Y. Wang, Z. Li, X. Yang, J. Yan. [Towards Unified INT8 Training for Convolutional Neural Network](https://xhplus.github.io/publication/conference-paper/cvpr2020/int8_training/). *IEEE Conference on Computer Vision and Pattern Recognition (CVPR)*, 2020.

- Y. Li, R. Gong, F. Yu, X. Dong, X. Liu#. [DMS: Differentiable Dimension Search for Binary Neural Networks](https://xhplus.github.io/publication/conference-paper/iclr2020/dms/), *International Conference on Learning Representations workshop on Neural Architecture Search (ICLR NAS workshop)*, 2020.

- Y. Wu, Y. Wu, R. Gong, Y. Lv, K. Chen, D. Liang, X. Hu, X. Liu#, J. Yan.
  [Rotation Consistent Margin Loss for Efficient Low-bit Face Recognition](https://xhplus.github.io/publication/conference-paper/cvpr2020/rcm_loss/). *IEEE Conference on Computer Vision and Pattern Recognition (CVPR)*, 2020.

- M. Shen, X. Liu, R. Gong, K. Han. [Balanced Binary Neural Networks with Gated Residual](https://xhplus.github.io/publication/conference-paper/icassp2020/bbg/). *IEEE International Conference on Acoustics, Speech, and Signal Processing*, 2020.

- R. Gong, X. Liu#, S. Jiang, T. Li, P. Hu, J. Lin, F. Yu, J. Yan. [Differentiable Soft Quantization: Bridging Full-Precision and Low-Bit Neural Networks](https://xhplus.github.io/publication/conference-paper/iccv2019/dsq/). *IEEE International Conference on Computer Vision (CVPR)*, 2019.
