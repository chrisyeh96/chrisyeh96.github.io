---
title: Binary vs. Multi-Class Logistic Regression
layout: post
use_math: true
use_toc: true
excerpt: I've been taught binary logistic regression using the sigmoid function, and multi-class logistic regression using a softmax. However, I have never quite understood how the two are related. In this post, I show exactly how multi-class logistic regression generalizes the binary case.
---

## Background

### Sigmoid
For a scalar real number $$z$$, the **sigmoid** function (aka. **standard logistic function**) is defined as

$$\sigma(z) = \frac{1}{1 + e^{-z}}$$

It outputs values in the range $$(0, 1)$$, not inclusive. This property makes it very useful for interpreting a real-valued score $$z$$ as a probability.
- as $$z \to -\infty$$, then $$\sigma(z) \to 0$$
- when $$z = 0$$, $$\sigma(z) = 1/2$$
- as $$z \to +\infty$$, then $$\sigma(z) \to 1$$

The derivative of the sigmoid function is $$\sigma'(z) = \sigma(z)(1-\sigma(z))$$.

### Softmax
For a vector $$x \in \R^n$$, the **softmax** function is defined as

$$\text{softmax}(x)_i = \frac{ e^{x_i} }{ \sum_{j=1}^n e^{x_j} }$$

Each element in $$\text{softmax}(x)$$ is squashed to the range $$[0, 1]$$, and the sum of the elements is 1. Thus, the softmax function is useful for converting an arbitrary vector of real numbers into a discrete probability distribution.

#### Numerical Stability
Let $$c$$ be some scalar. Then,

$$
\begin{align*}
  \text{softmax}(x + c)_i
  &= \frac{ e^{x_i + c} }{ \sum_{j=1}^n e^{x_j + c} } \\
  &= \frac{ e^{x_i} e^c }{ \sum_{j=1}^n e^{x_j} e^c } \\
  &= \frac{ e^{x_i} }{ \sum_{j=1}^n e^{x_j} } \\
  &= \text{softmax}(x)_i
\end{align*}
$$

This property of the softmax function is often exploited to improve numerical stability. If we choose $$c = - \max_i x_i$$, then $$\max_i e^{x_i + c} = 1$$. We also have $$\min_i e^{x_i} > 0$$ since the exponential function is always positive. Thus, we can always constrain each term of the denominator to the range $$(0, 1]$$.

Doing so helps avoid underflow when the $$x_i$$ are all very small. When the $$x_i$$ are all small, $$e^{x_i}$$ may underflow to 0, leading to division by 0. When we shift the $$x_i$$ by $$c = - \max_i x_i$$, at least one of the terms in the denominator is $$\max_i e^{x_i + c} = 1$$, thus avoiding the division-by-zero error.

Shifting the $$x_i$$ by $$c$$ also helps avoid overflow, since the exponential function grows very fast. For example, using 16-bit (half-precision) floating point numbers, $$e^{12}$$ is already greater than the maximum representable number and is rounded to `+inf` instead. When we shift the $$x_i$$ by $$c = - \max_i x_i$$, we have $$\max_i e^{x_i + c} = 1$$, so no single term will overflow. For any practical size of vector $$x_i$$, the sum in the denominator would not overflow either.

### Cross-Entropy
For two probability distributions $$p(x)$$ and $$q(x)$$, the **cross-entropy** function is a measure of how different they are. It is defined as

$$H(p,q) = - \E_{x \sim p} [\log q(x)]$$

If $$p$$ and $$q$$ are discrete, then we have $$H(p,q) = - \sum_{x} p(x) \log q(x)$$.

Some key properties:
- $$H(p,q)$$ is only defined if $$q(x) > 0$$ wherever $$p(x) > 0$$. Otherwise, if $$p(x) > 0$$ but $$q(x) = 0$$ for some $$x$$, then we will have a term $$p(x) \log 0$$, which is undefined. By convention, in the case that $$p(x) = q(x) = 0$$, we treat $$p(x) \log q(x)$$ as $$\lim_{x \to 0} x \log x = 0$$.
- range: $$[0, \infty)$$
  - 0: choose $$p(x) = q(x)$$ with both equal to 1 at some particular $$x$$ and 0 elsewhere
  - $$\infty$$: choose $$q(x)$$ to be very small when $$p(x)$$ is large
- not symmetric: $$H(p,q)$$ is usually not equal to $$H(q,p)$$
- Even when $$p = q$$, the cross-entropy can be non-zero. This can be made especially clear by rewriting the function as $$H(p,q) = H(p) + D_{KL}(p\|q)$$, where $$H(p)$$ is the entropy of $$p$$, since both entropy and KL-divergence are always non-negative.

When used as a loss function, we set $$p = y$$ (the labels) and $$q = \hat{y}$$ (the predictions). In the classification setting where each example belongs to exactly 1 class, $$y$$ is a one-hot vector with 1 at the index of the true class, and $$\hat{y}$$ is a vector representing a discrete probability distribution over the possible classes.

### Convex Functions

A function $$f : \R^n \to \R$$ is **convex** if for all $$x, y$$ in its domain, and with $$0 \leq a \leq 1$$, we have

$$f(ax + (1-a)y) \leq a f(x) + (1-a) f(y) $$

A function $$f$$ is **strictly convex** if strict inequality holds whenever $$x \neq y$$ and $$0 < a < 1$$.

For this post, assume the following true statements about convex functions:
- If $$f$$ is convex, performing gradient descent on $$f(w)$$ with a small enough step size is guaranteed to converge to a global minimum of $$f$$.
- If $$f$$ is strictly convex, then it has a unique global minimum. (The converse is not necessarily true.)

## Binary Logistic Regression

**Data**: $$(x, y)$$ pairs, where each $$x$$ is a feature vector of length $$M$$ and the label $$y$$ is either 0 or 1

**Goal**: predict $$y$$ for a given $$x$$

**Model**: For an example $$x$$, we calculate the **score** as $$z = w^T x + b$$ where vector $$w \in \R^M$$ and scalar $$b \in \R$$ are parameters to be learned from data. If we just want to predict the binary value of $$y$$, then we would set a threshold (typically 0) on the score: $$\hat{y} = \mathbf{1}[z \geq 0]$$. While 0 is the most commonly used threshold, we could actually choose any threshold since we could always change the scalar $$b$$ to compensate accordingly.

There are two issues with the model which uses a simple threshold on the score. First, it is difficult to define a differentiable loss function $$\text{loss}(y, \hat{y})$$ when both $$y$$ and $$\hat{y}$$ are discrete numbers 0 or 1. Second, we frequently want a probabilistic interpretation for the score. Thus, we introduce the sigmoid function $$\sigma$$ which maps all scores into the range $$(0,1)$$:

$$p(y=1) = \sigma(z) = \sigma(w^T x + b)$$

For a given $$x$$, if $$p(y=1) \geq 0.5$$, then we predict $$\hat{y}=1$$. Otherwise we predict $$\hat{y}=0$$. Note that this setup is identical to setting a 0-threshold on the score.

In the equation above, if we solve for the score $$z$$, we see that we can interpret the score as the log-odds of $$y=1$$ (a.k.a. the **logits**).

$$
\begin{equation*}
    p(y=1) = \sigma(z) = \frac{1}{1 + e^{-z}} \\
    1 + e^{-z} = \frac{1}{p(y=1)} \\
    e^{-z} = \frac{1}{p(y=1)} - 1 = \frac{1 - p(y=1)}{p(y=1)} \\
    e^z = \frac{p(y=1)}{1 - p(y=1)} \\
    z = \log \frac{p(y=1)}{1 - p(y=1)} \\
\end{equation*}
$$

**Loss function**: For a single example $$x$$ with score $$z$$ and label $$y$$, the logistic loss function is

$$
\begin{align*}
\text{loss}
&= -y\log(\sigma(z)) - (1-y)\log(1 - \sigma(z)) \\
&= \begin{cases}
    -\log(1 - \sigma(z)) & y = 0 \\
    -\log(\sigma(z))     & y = 1
   \end{cases} \\
&= \begin{cases}
    -\log(\frac{e^{-z}}{1 + e^{-z}}) & y = 0 \\
    \log(1 + e^{-z})                 & y = 1
   \end{cases} \\
&= \begin{cases}
    \log(1 + e^z)    & y = 0 \\
    \log(1 + e^{-z}) & y = 1
   \end{cases} \\
\end{align*}
$$

In the 2nd line of the equation above, it is clear that in the probabilistic interpretation of our model, this loss function is exactly the negative log probability of a single example $$x$$ having true label $$y$$. Thus, minimizing the sum of the loss over our training examples is equivalent to maximizing the log likelihood. We can see this as follows:

$$
\begin{align*}
  p(y|x; w,b) &=
    \begin{cases}
    \sigma(z),     & y=1 \\
    1 - \sigma(z), & y=0
    \end{cases}
    = \sigma(z)^y (1-\sigma(z))^{(1-y)} \\
  \log p(y|x; w,b) &= y \log \sigma(z) + (1-y) \log (1-\sigma(z))
\end{align*}
$$

We can learn the model parameters $$w$$ and $$b$$ by performing gradient descent on the loss function with respect to these parameters. The logistic loss function is convex (though not necessarily strictly convex) in the parameters $$w$$ and $$b$$, so it is guaranteed to converge to a globally optimal value with a small enough learning rate. If we regularize parameters by adding $$\lambda \|w\|^2_2$$ to the loss function for some regularization constant $$\lambda > 0$$, then the loss function is strictly convex and has a unique global minimum.

### Notation: $$y \in \{0, 1\}$$ vs. $$y \in \{+1, -1\}$$

We've assumed that the binary label is $$y \in \{0, 1\}$$. However, it is also common to see $$y \in \{+1, -1\}$$. In this case, only the prediction and loss functions change, but the results are identical.
- prediction: $$\hat{y} = \text{sign}(z)$$
- loss function: $$\text{loss} = \log(1 + e^{-yz})$$

### Generalization: Multi-Label Classification

So far we have examined the situation where each training example $$x$$ either belongs to a particular class ($$y=1$$) or it does not ($$y=0$$). However, we can generalize this notion to the case where $$x$$ can belong to many classes simultaneously, with $$y \in \{0, 1\}^C$$ where $$C$$ is the number of classes. Concretely, if inputs are images, and we have 3 classes ("dog", "car", "tree"), then $$y = [0, 1, 1]$$ could indicate that a particular image contains a car and a tree.

**General model**: For an example $$x \in \R^M$$, we calculate the **score** as $$z = W^T x + b$$ where matrix $$W \in \R^{C \times M}$$ and vector $$b \in \R^C$$ are parameters to be learned from data. The probabilities for each class are given by the sigmoid of each class score: $$p(y_c=1) = \sigma(z_c) = \sigma(W_c^T x + b)$$. This is basically a vectorized implementation of $$C$$ separate binary logistic regression models, one for each class.

One downside of training a separate binary logistic regression model for each class is that it assumes the probabilities for each class are independent. For example, suppose we have a dataset of images of objects, and each image is labeled for two binary attributes: "is/isn't expensive" and "is/isn't a car". If all cars are expensive, then the model should be able to learn to predict "is expensive" for every image that "is a car". However, because we have separate classifiers for each attribute, the classifiers may output "isn't expensive" for an image that "is a car."


### TensorFlow implementation

In TensorFlow (as of version r1.8), there are two built-in functions for the logistic loss function. TensorFlow assumes that the binary label is $$y \in \{0, 1\}$$.
1. `tf.nn.sigmoid_cross_entropy_with_logits(labels=y, logits=z)` ([API documentation](https://www.tensorflow.org/api_docs/python/tf/nn/sigmoid_cross_entropy_with_logits))
2. `tf.losses.sigmoid_cross_entropy(multi_class_labels=y, logits=z)` ([API documentation](https://www.tensorflow.org/api_docs/python/tf/losses/sigmoid_cross_entropy))

These operations compute exactly the logistic loss function defined above. Consider the common input shapes for `z` and `y`:
- scalars, representing the score and label of a single example
- vectors, either
  - of shape `[batch_size]`, representing the scores and labels of a batch of examples, or
  - of shape `[num_classes]`, representing the scores and labels of a single example that could simultaneously belong to multiple classes (`tf.nn` variant only)
- tensors of shape `[batch_size, num_classes]`, in the case where each example could simultaneously belong to multiple classes (ie. $$y \in \{0, 1\}^C$$ where $$C$$ is the number of classes)

The difference between the 2 different TensorFlow functions is that the `tf.losses` variant assumes that the first dimension of `y` and `z` is `batch_size` and performs a reduction operation over the batch of examples after computing their individual losses. By default, this function uses a sum-reduction, but this can be changed via the `reduction` parameter.


## Multinomial Logistic Regression (via Cross-Entropy)

The multi-class setting is similar to the binary case, except the label $$y$$ is now an integer in $$1, \dots, C$$ where $$C$$ is the number of classes. As before, we use a score function. However, now we calculate scores for all classes, instead for just the positive class.

**Model**: For an example $$x$$, the class **scores** are given by vector $$z = Wx + b$$, where $$W$$ is a $$C \times M$$ matrix and $$b$$ is a length $$C$$ vector of biases. If we just want to predict the class label $$y$$, then we just choose the class with the highest score: $$\hat{y} = \arg\max_i z_i$$.

As in the binary case, however, we frequently seek a discrete probability distribution over the possible classes. We will abuse notation by letting $$y$$ and $$\hat{y}$$ be vectors denoting probability distributions. We define the label $$y$$ as a one-hot vector equal to 1 for the correct class $$c$$ and 0 everywhere else. Then we use the softmax function to get our predicted probability distribution from the class scores, where $$\hat{y}_i$$ is our model's estimate for $$p(y=i)$$:

$$ \hat{y} = \text{softmax}(z) $$

**Loss function**: Now that we are considering two discrete probability distributions $$y$$ and $$\hat{y}$$, a natural choice for the loss function is the cross-entropy loss function. The loss for a training example $$x$$ with predicted class distribution $$\hat{y}$$ and correct class $$c$$ is

$$
\begin{align*}
  \text{loss}
  &= H(y,\hat{y}) \\
  &= - \sum_{i} y_i \log \hat{y}_i \\
  &= - \log \hat{y}_c \\
\end{align*}
$$

As in the binary case, the loss value $$- \log \hat{y}_c$$ is exactly the negative log probability of a single example $$x$$ having true class label $$c$$. Thus, minimizing the sum of the loss over our training examples is equivalent to maximizing the log likelihood.

We can learn the model parameters $$W$$ and $$b$$ by performing gradient descent on the loss function with respect to these parameters. As in the binary logistic regression case, the loss function is convex (but not strictly convex due to over-parameterization, see below), so gradient descent will converge to a global minimum with a small enough step size. With $$L_2$$-regularization on both $$W$$ and $$b$$, the loss function becomes strictly convex.

### Over-parameterization

The softmax model is actually **over-parameterized**, meaning that for model we fit to the data, there are multiple parameter settings that give rise to exactly the same function mapping from inputs $$x$$ to the predictions. If we add a constant vector $$v$$ to all of the coefficient vectors $$W_i$$ and a constant bias $$d$$ to each $$b_i$$, the equations are identical:

$$
\begin{align*}
  \hat{y}_c
  &= \frac{e^{(W_c + v) \cdot x + (b_c + d)}}{\sum_i e^{(W_i + v) \cdot x + (b_i + d)}} \\
  & = \frac{e^{W_c \cdot x + b_c} e^{v \cdot x + d}}{\sum_i e^{W_i \cdot x + b_i} e^{v \cdot x + d}} \\
  & = \frac{e^{W_c \cdot x + b_c}}{\sum_i e^{W_i \cdot x + b_i}}
\end{align*}
$$

Thus, if the loss function $$J(W)$$ is minimized by some setting of the parameters $$(W_1, \dots, W_C, b_1, \dots, b_C)$$, then it is also minimized by $$(W_1 - v, \dots, W_C - v, b_1 - d, \dots, b_C - d)$$ for any vector $$v$$ and any scalar $$d$$. There is no unique set of weights that minimizes the loss function. Even so, the loss function is still convex (though clearly not strictly convex) so gradient descent will still find a global minimum ([source](http://ufldl.stanford.edu/wiki/index.php/Softmax_Regression)).

For each example $$x$$, we could always choose $$v=−W_C$$ and $$d=−b_C$$ such that the last class has score 0. In other words, we could actually just have weights and biases for just the first $$C−1$$ classes only.

### The binary case

To show that multinomial logistic regression is a generalization of binary logistic regression, we will consider the case where there are 2 classes (ie. $$C=2$$). In this case, we have predictions

$$
\hat{y} = \frac{1}{e^{W_1 \cdot x + b_1} + e^{W_2 \cdot x + b_2}}
\begin{bmatrix}
e^{W_1 \cdot x + b_1} \\
e^{W_2 \cdot x + b_2}
\end{bmatrix}
$$

Suppose our model has learned $$W$$ and $$b$$. Taking advantage of the over-parameterization of our model, we know that the predicted probabilities are equivalent if we subtract some constant vector $$v$$ from the weights $$W_1, W_2$$ and scalar $$d$$ from the biases $$b_1, b_2$$. Choosing $$v = W_2$$ and $$d = b_2$$, we get

$$
\begin{align*}
  \hat{y} &= \frac{1}{e^{(W_1-W_2)^T x + (b_1-b_2)} + e^0}
    \begin{bmatrix}
    e^{(W_1-W_2)^T x + (b_1-b_2)} \\
    e^{0}
    \end{bmatrix} \\
  &= \begin{bmatrix}
    \frac{ e^{W'^T x + b'} }{ 1 + e^{W'^T x + b'} } \\
    \frac{ 1 }{ 1 + e^{W'^T x + b'} }
    \end{bmatrix} \\
  &= \begin{bmatrix}
    1 - \sigma (W'^T x + b') \\
    \sigma (W'^T x + b')
    \end{bmatrix} \\
\end{align*}
$$

where $$W' = W_1 - W_2$$ and $$b' = b_1 - b_2$$. We see that the learned probabilities have the same form as logistic regression.

Likewise, the cross-entropy loss with two classes, where the correct class is $$c$$, becomes

$$
\begin{align*}
  \text{loss}
  &= H(y,\hat{y}) \\
  &= - \log \hat{y}_c \\
  &= \begin{cases}
    -\log(1 - \sigma(z)) & y = 0 \\
    -\log(\sigma(z))     & y = 1
   \end{cases} \\
\end{align*}
$$

which is identical to the logistic regression version.

### TensorFlow implementation

In TensorFlow (as of version r1.8), there are several built-in functions for the cross-entropy loss.

1. `tf.nn.softmax_cross_entropy_with_logits_v2(labels=y, logits=z)`. This operation computes exactly the loss function defined above, where `z` contains the scores and `y` has the one-hot labels. Both `z` and `y` should have shape `[batch_size, num_classes]`. If they are a batch of examples, then you have to run `tf.reduce_mean()` or `tf.reduce_sum()` to get the total loss. ([API documentation](https://www.tensorflow.org/api_docs/python/tf/nn/softmax_cross_entropy_with_logits_v2))
2. `tf.nn.sparse_softmax_cross_entropy_with_logits`. This is similar to the previous function, except it takes labels `y` as the integer for the correct class, without converting it to a one-hot label. ([API documentation](https://www.tensorflow.org/api_docs/python/tf/nn/sparse_softmax_cross_entropy_with_logits))
3. `tf.losses.softmax_cross_entropy(onehot_labels=y, logits=z)` and `tf.losses.sparse_softmax_cross_entropy(labels=y, logits=z)`. Both of these are similar to `tf.nn` functions above, but they combine the loss calculation and reduction over a batch of examples. By default, they function apply a sum-reduction, but this can be changed via the `reduction` parameter. ([API documentation](https://www.tensorflow.org/api_docs/python/tf/losses/))

### Sources

- [The Multinomial Logit Model (Princeton)](http://data.princeton.edu/wws509/notes/c6s2.html)
- [Softmax Regression Tutorial (UFLDL)](http://ufldl.stanford.edu/wiki/index.php/Softmax_Regression)
- [Multinomial Logistic Regression (Wikipedia)](https://en.wikipedia.org/wiki/Multinomial_logistic_regression)
- [Theoretic Concepts of Machine Learning (JKU)](http://www.bioinf.jku.at/teaching/current/ss_vl_tcml/ML_theoretical.pdf), Sections 4.3.3 and 4.3.5

## Multi-class Logistic Regression: one-vs-all and one-vs-rest

Given a binary classification algorithm (including binary logistic regression, binary SVM classifier, etc.), there are two common approaches to use them for multi-class classification: **one-vs-rest** (also known as **one-vs-all**) and **one-vs-one**. Each has its strengths and weaknesses. There is no clear "best" multi-class classification model; it depends on the dataset.

In **one-vs-rest**, we train $$C$$ separate binary classification models. Each classifier $$f_c$$, for $$c \in \{ 1, \dotsc, C\}$$ is trained to determine whether or not an example is part of class $$c$$ or not. To predict the class for a new example $$x$$, we run all $$C$$ classifiers on $$x$$ and choose the class with the highest score: $$\hat{y} = \arg\max_{c \in \{ 1, \dotsc, C\}} f_c(x)$$. One main drawback is that when there are lots of classes, each binary classifier sees a highly imbalanced dataset, which may degrade performance.

In **one-vs-one**, we train $${C \choose 2} = C(C-1)/2$$ separate binary classification models, one for each possible pair of classes. To predict the class for a new example $$x$$, we run all $${C \choose 2}$$ classifiers on $$x$$ and choose the class with the most "votes." A major drawback is that there can exist fairly large regions in the decision space with ties for the class with the most number of votes.

### Sources

- [Multiclass classification](https://en.wikipedia.org/wiki/Multiclass_classification)
- [Scalable Machine Learning (UC Davis)](http://www.stat.ucdavis.edu/~chohsieh/teaching/ECS289G_Fall2015/lecture9.pdf)

## Deep Learning with Logistic Regression

In the settings above, we assumed our dataset consisted of $$(x, y)$$ pairs where each $$x$$ is a feature vector. Note that we can easily use a deep neural network (or any other type of transformation) $$x \to x'$$ and then perform logistic regression on $$(x', y)$$ pairs. In a classification setting, logistic / softmax regression is just a convenient final layer that maps feature vectors to a class label.
