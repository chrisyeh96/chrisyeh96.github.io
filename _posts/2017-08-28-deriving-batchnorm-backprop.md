---
title: Deriving Batch-Norm Backprop Equations
layout: post
use_math: true
use_toc: true
excerpt: I present a derivation of efficient backpropagation equations for batch-normalization layers.
---

## Introduction

A batch normalization layer is given a batch of $$N$$ examples, each of which is a $$D$$-dimensional vector. We can represent the inputs as a matrix $$X \in \R^{N \times D}$$ where each row $$x_i$$ is a single example. Each example $$x_i$$ is normalized by

$$ \hat{x}_i = \frac{x_i - \mu}{\sqrt{\sigma^2 + \epsilon}} $$

where $$\mu, \sigma^2 \in \R^{1 \times D}$$ are the mean and variance, respectively, of each input dimension across the batch. $$\epsilon$$ is some small constant that prevents division by 0. The mean and variance are computed by

$$
\begin{align*}
  \mu &= \frac{1}{N} \sum_i x_i \\
  \sigma^2 &= \frac{1}{N} \sum_i (x_i - \mu)^2
\end{align*}
$$

An affine transform is then applied to the normalized rows to produce the final output

$$ y_i = \gamma \cdot \hat{x}_i + \beta $$

where $$\gamma, \beta \in \R^{1 \times D}$$ are learnable scale parameters for each input dimension. For notational simplicity, we can express the entire layer as

$$
\begin{align*}
  \hat{X} &= \frac{X - \mu}{\sqrt{\sigma^2 + \epsilon}} \\
  Y &= \gamma \odot \hat{X} + \beta
\end{align*}
$$

**Notation**: $$\odot$$ denotes the Hadamard (element-wise) product. In the case of $$\gamma \odot \hat{X}$$, where $$\gamma$$ is a row vector and $$\hat{X}$$ is a matrix, each row of $$\hat{X}$$ is multiplied element-wise by $$\gamma$$.

**Gradient Notes**: Several times throughout this post, I mention my "gradient notes" which refers to [this document](https://www.overleaf.com/read/cxjrxqhkvfyb).

## Backpropagation Basics

Let $$J$$ be the training loss. We are given $$\frac{\partial J}{\partial Y} \in \R^{N \times D}$$, the gradient signal with respect to $$Y$$. Our goal is to calculate three gradients:

1. $$\frac{\partial J}{\partial \gamma} \in \R^{1 \times D}$$, to perform a gradient descent update on $$\gamma$$
2. $$\frac{\partial J}{\partial \beta} \in \R^{1 \times D}$$, to perform a gradient descent update on $$\beta$$
3. $$\frac{\partial J}{\partial X} \in \R^{N \times D}$$, to pass on the gradient signal to lower layers

Both $$\frac{\partial J}{\partial \gamma}$$ and $$\frac{\partial J}{\partial \beta}$$ are straightforward. Let $$y_i$$ be the $$i$$-th row of $$Y$$. We refer to our gradient notes to get

$$\boxed{
\frac{\partial J}{\partial \gamma} = \sum_i \frac{\partial J}{\partial y_i} \odot \hat{x}_i
}$$

$$\boxed{
\frac{\partial J}{\partial \beta} = \sum_i \frac{\partial J}{\partial y_i}
}$$

Deriving $$\frac{\partial J}{\partial X}$$ requires backpropagation through $$Y = \gamma \odot \hat{X} + \beta$$, which yields

$$
\begin{align*}
\frac{\partial J}{\partial \hat{x}_{ij}} &= \frac{\partial J}{\partial y_{ij}} \cdot \gamma_j \\
\frac{\partial J}{\partial \hat{X}} &= \gamma \odot \frac{\partial J}{\partial Y}
\end{align*}
$$

Next we have to backpropagate through $$\hat{X} = \frac{X - \mu}{\sqrt{\sigma^2 + \epsilon}} = (\sigma^2 + \epsilon)^{-1/2}(X - \mu)$$. Because both $$\sigma^2$$ and $$\mu$$ are functions of $$X$$, finding the gradient of $$J$$ with respect to $$X$$ is tricky. There are two approaches to break this down:

1. Take the gradient of $$J$$ with respect to each **row** (example) in $$X$$. This approach is complicated by the fact that the values of each row in $$X$$ influence the values of **all** rows in $$\hat{X}$$ (i.e. $$\partial \hat{x}_{j \neq i} / \partial x_i \neq 0$$). By properly considering how changes in $$x_i$$ influence $$\mu$$ and $$\sigma^2$$, this is doable, as explained [here](https://costapt.github.io/2016/07/09/batch-norm-alt/).
2. Take the gradient of $$J$$ with respect to each **column** (input dimension) in $$X$$. I find this more intuitive because batch normalization operates independently for each column - $$\mu$$, $$\sigma^2$$, $$\lambda$$, and $$\beta$$ are all calculated per column. This method is explained below.

## Column-wise Gradient

Since we are taking the gradient of $$J$$ with respect to each **column** in $$X$$, we can start by considering the case where $$X$$ is just a single column vector. Thus, each example $$x_i$$ is a single number, and $$\mu$$ and $$\sigma$$ are scalar real numbers. This makes the math much easier. Later on, we generalize to $$D$$-dimensional input examples.

### Lemma

Let $$a(B) \in \R$$ be a real-valued function of vector $$B \in \R^n$$. Suppose $$\frac{\partial a}{\partial B} \in \R^n$$ is known. If $$B = c(D) \cdot D$$ where $$c(D) \in \R$$ and $$D \in \R^n$$, then

$$ \frac{\partial a}{\partial D} = \left( \frac{\partial c}{\partial D} D^T + c(D) I \right) \frac{\partial a}{\partial B} $$

*Proof*

First we compute the gradient of $$B$$ for a single element in $$D$$.

$$
\frac{\partial B_k}{\partial D_i}
= \frac{\partial}{\partial D_i} \left[ c(D) \cdot D_k \right]
= \frac{\partial c}{\partial D_i} D_k + \mathbf{1}[i=k]c(D)
$$

We apply the chain rule to obtain the gradient of $$a$$ for a single element in $$D$$.

$$
\begin{align*}
\frac{\partial a}{\partial D_i}
&= \sum_k \frac{\partial a}{\partial B_k} \frac{\partial B_k}{\partial D_i} \\
&= \sum_k \frac{\partial a}{\partial B_k} \left( \frac{\partial c}{\partial D_i} D_k + \mathbf{1}[i=k]c(D) \right) \\
&= \frac{\partial c}{\partial D_i} \left( \sum_k \frac{\partial a}{\partial B_k} D_k \right) + c(D) \frac{\partial a}{\partial B_i} \\
&= \frac{\partial c}{\partial D_i} \left( D^T \frac{\partial a}{\partial B} \right) + c(D) \frac{\partial a}{\partial B_i}
\end{align*}
$$

Now we can write the gradient for all elements in $$D$$, where $$I$$ is the $$n \times n$$ identity matrix.

$$
\frac{\partial a}{\partial D}
= \frac{\partial c}{\partial D} \left( D^T \frac{\partial a}{\partial B} \right) + c(D) \frac{\partial a}{\partial B}
= \left( \frac{\partial c}{\partial D} D^T + c(D) I \right) \frac{\partial a}{\partial B}
\tag*{$\blacksquare$}
$$

This result is a generalization of the "product rule" in the completely scalar case. For a function $$a(b)$$ where $$b=c(d) \cdot d$$, we have

$$
\begin{align*}
\frac{\text{d}b}{\text{d}d}
& = \frac{\text{d}c}{\text{d}d} \cdot d + \frac{\text{d}d}{\text{d}d} \cdot c(d)
= \frac{\text{d}c}{\text{d}d} \cdot d + c(d) \\
\frac{\text{d}a}{\text{d}d}
&= \frac{\text{d}a}{\text{d}b} \cdot \frac{\text{d}b}{\text{d}d}
= \left( \frac{\text{d}c}{\text{d}d} \cdot d + c(d) \right) \frac{\text{d}a}{\text{d}b}
\end{align*}
$$

### Getting a single expression for $$\frac{\partial J}{\partial X}$$

We want a single expression for $$\frac{\partial J}{\partial X}$$, which we will derive in two steps.

1. Rewrite $$\hat{X}$$ in the form $$\hat{X} = c(R) \cdot R$$ for some choice of $$R$$ and $$c(R)$$. This enables us to use the lemma above to obtain $$\frac{\partial J}{\partial R}$$.
2. Rewrite $$R$$ in the form $$R = A \cdot X$$ for some choice of $$A$$. This enables us to use our gradient notes to obtain $$\frac{\partial J}{\partial X}$$.

We choose $$R = X-\mu$$. Then $$\hat{X}$$ can be expressed in terms of $$R$$ as follows:

$$
\begin{gather*}
  \sigma^2 = \frac{1}{N} \sum_i (x_i-\mu)^2
    = \frac{1}{N} (X-\mu)^T (X-\mu)
    = \frac{1}{N} R^T R \\
  \hat{X} = \frac{X - \mu}{\sqrt{\sigma^2 + \epsilon}}
    = \left( \frac{1}{N} R^T R + \epsilon \right)^{-1/2} \cdot R
    = c(R) \cdot R
\end{gather*}
$$

where $$c(R) = (\sigma^2 + \epsilon)^{-1/2} = (\frac{1}{N} R^T R + \epsilon)^{-1/2}$$. Now we apply our lemma above.

$$
\frac{\partial J}{\partial R}
= \left( \frac{\partial c}{\partial R} R^T + c(R) I \right) \frac{\partial J}{\partial \hat{X}}
$$

$$R$$ can be written as a matrix multiplication with $$X$$, where $$\mathbf{1}$$ is a $$N \times N$$ matrix of all ones.

$$ R
= X - \mu
= X - \frac{1}{N} \mathbf{1} X
= \left(I - \frac{1}{N} \mathbf{1} \right) \cdot X
$$

Using our gradient rules, we get

$$
\frac{\partial J}{\partial X}
= \left(I - \frac{1}{N} \mathbf{1} \right)^T \frac{\partial J}{\partial R}
= \left(I - \frac{1}{N} \mathbf{1} \right) \left[ \frac{\partial c}{\partial R} R^T + c(R) I \right] \frac{\partial J}{\partial \hat{X}}
$$

### Simplifying the expression

First, we calculate

$$
\begin{align*}
\frac{\partial c}{\partial R}
&= \frac{\partial}{\partial R} \left( \frac{1}{N} R^T R + \epsilon \right)^{-1/2} \\
&= -\frac{1}{2} \left( \frac{1}{N} R^T R + \epsilon \right)^{-3/2} \cdot \frac{\partial}{\partial R} \left( \frac{1}{N} R^T R + \epsilon \right) \\
&= -\frac{1}{2} \left( \frac{1}{N} R^T R + \epsilon \right)^{-3/2} \cdot \frac{2}{N} R \\
&= -\frac{1}{N} \left( \frac{1}{N} R^T R + \epsilon \right)^{-3/2} \cdot R \\
&= -\frac{1}{N} (\sigma^2 + \epsilon)^{-3/2} (X - \mu)
\end{align*}
$$

We plug this into our equation for $$\frac{\partial J}{\partial X}$$ and rewrite $$R$$ and $$c(R)$$ in terms of $$\mu$$ and $$\sigma$$:

$$
\begin{align*}
\frac{\partial J}{\partial X}
&= \left(I - \frac{1}{N} \mathbf{1} \right) \left[ \frac{\partial c}{\partial R} R^T + c(R) I \right] \frac{\partial J}{\partial \hat{X}} \\
&= \left(I - \frac{1}{N} \mathbf{1} \right) \left[ -\frac{1}{N} (\sigma^2 + \epsilon)^{-3/2} (X-\mu) (X-\mu)^T + (\sigma^2 + \epsilon)^{-1/2} I \right] \frac{\partial J}{\partial \hat{X}} \\
&= (\sigma^2 + \epsilon)^{-1/2} \left(I - \frac{1}{N} \mathbf{1} \right) \left[ -\frac{1}{N} \frac{(X-\mu)}{\sqrt{\sigma^2 + \epsilon}} \frac{(X-\mu)^T}{\sqrt{\sigma^2 + \epsilon}} + I \right] \frac{\partial J}{\partial \hat{X}} \\
&= (\sigma^2 + \epsilon)^{-1/2} \left(I - \frac{1}{N} \mathbf{1} \right) \left[ -\frac{1}{N} \hat{X} \hat{X}^T + I \right] \frac{\partial J}{\partial \hat{X}} \\
&= (\sigma^2 + \epsilon)^{-1/2} \left[-\frac{1}{N} \hat{X} \hat{X}^T + I + \frac{1}{N^2} \mathbf{1} \hat{X} \hat{X}^T - \frac{1}{N} \mathbf{1} \right] \frac{\partial J}{\partial \hat{X}} \\
&= (\sigma^2 + \epsilon)^{-1/2} \left[-\frac{1}{N} \hat{X} \hat{X}^T + I - \frac{1}{N} \mathbf{1} \right] \frac{\partial J}{\partial \hat{X}}
\end{align*}
$$

The last step above is because $$\mathbf{1} \hat{X}$$ is the 0-vector:

$$
\begin{bmatrix}
  1 & \cdots & 1 \\
  \vdots & \ddots & \vdots\\
  1 & \cdots & 1
\end{bmatrix}
\begin{bmatrix}
  x_1 - \mu \\
  \vdots \\
  x_N - \mu \\
\end{bmatrix}
\rightarrow
\text{each element in the resulting vector is}
\sum_{i=1}^{N} (x_i - \mu) = 0
$$

Note that when the inputs are scalars, $$\frac{\partial J}{\partial \hat{X}} = \gamma \cdot \frac{\partial J}{\partial Y}$$ where $$\gamma$$ is a scalar and $$\frac{\partial J}{\partial Y}$$ is a column vector. Thus,

$$
\begin{align*}
\frac{\partial J}{\partial X}
&= (\sigma^2 + \epsilon)^{-1/2} \left[-\frac{1}{N} \hat{X} \hat{X}^T + I - \frac{1}{N} \mathbf{1} \right] \frac{\partial J}{\partial \hat{X}} \\
&= \gamma (\sigma^2 + \epsilon)^{-1/2} \left[-\frac{1}{N} \hat{X} \hat{X}^T \frac{\partial J}{\partial Y} + \frac{\partial J}{\partial Y} - \frac{1}{N} \mathbf{1} \frac{\partial J}{\partial Y} \right] \\
&= \frac{1}{N} \gamma (\sigma^2 + \epsilon)^{-1/2} \left[-\frac{\partial J}{\partial \gamma} \hat{X} + N \frac{\partial J}{\partial Y} - \mathbf{1}_N \cdot \frac{\partial J}{\partial \beta} \right]
\end{align*}
$$

where $$\mathbf{1}_N$$ is a $$N$$-dimensional column vector of ones. The last line uses the fact that when the input examples are scalars, the derivatives simplify to

$$
\begin{align*}
\frac{\partial J}{\partial \gamma}
&= \sum_i \frac{\partial J}{\partial y_i} \cdot \hat{x}_i
= \hat{X}^T \frac{\partial J}{\partial Y} \\
\frac{\partial J}{\partial \beta}
&= \sum_i \frac{\partial J}{\partial y_i}
= \mathbf{1}_N^T \frac{\partial J}{\partial Y}
\end{align*}
$$

Finally, we generalize to the case when the input examples are $$D$$-dimensional vectors:

$$\boxed{
\frac{\partial J}{\partial X}
= \frac{1}{N} \gamma \odot (\sigma^2 + \epsilon)^{-1/2} \left[-\frac{\partial J}{\partial \gamma} \odot \hat{X} + N \frac{\partial J}{\partial Y} - \mathbf{1}_N \cdot \frac{\partial J}{\partial \beta} \right]
}$$


## References

- [Batch Normalization](https://arxiv.org/abs/1502.03167)
  - the original paper by Sergey Ioffe and Christian Szegedy
- [Efficient Batch Normalization](https://costapt.github.io/2016/07/09/batch-norm-alt/)
  - row-wise derivation of $$\frac{\partial J}{\partial X}$$
- [Deriving the Gradient for the Backward Pass of Batch Normalization](https://kevinzakka.github.io/2016/09/14/batch_normalization/)
  - another take on row-wise derivation of $$\frac{\partial J}{\partial X}$$
- [Understanding the backward pass through Batch Normalization Layer](https://kratzert.github.io/2016/02/12/understanding-the-gradient-flow-through-the-batch-normalization-layer.html)
  - (slow) step-by-step backpropagation through the batch normalization layer
- [Batch Normalization - What the Hey?](https://gab41.lab41.org/batch-normalization-what-the-hey-d480039a9e3b)
  - explains some intuition behind batch normalization
  - clarifies the difference between using batch statistics during training and sample statistics during inference
