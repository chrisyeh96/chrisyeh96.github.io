---
title: Bias-Variance Decomposition of Mean Squared Error
layout: post
use_math: true
use_toc: true
last_updated: 2022-12-05
tags: [ML]
excerpt: I derive the bias-variance decomposition of mean squared error for both estimators and predictors, and I show how they are related for linear models.
---

$$
\newcommand{\Noise}{\mathcal{E}}
\newcommand{\fh}{\hat{f}}
\newcommand{\fhR}{\hat{f}^\text{Ridge}}
\newcommand{\wh}{\hat{w}}
\newcommand{\whR}{\hat{w}^\text{Ridge}}
\newcommand{\Th}{\hat{T}}
\DeclareMathOperator*{\argmax}{arg\,max}
\DeclareMathOperator*{\argmin}{arg\,min}
\DeclareMathOperator{\Bias}{Bias}
\DeclareMathOperator{\Var}{Var}
\DeclareMathOperator{\Cov}{Cov}
\DeclareMathOperator{\tr}{tr}
$$

Mean squared error (MSE) is defined in two different contexts.
- The MSE of an *estimator* quantifies the error of a sample statistic relative to the true population statistic.
- The MSE of a regression *predictor* (or *model*) quantifies the generalization error of that model trained on a sample of the true data distribution.

This post discusses the bias-variance decomposition for MSE in both of these contexts. To start, we prove a generic identity.

**Theorem 1**: For any random vector $$X \in \R^p$$ and any constant vector $$c \in \R^p$$,

$$ \E[\|X-c\|_2^2] = \tr\Cov[X] + \|\E[X]-c\|_2^2. $$

<details markdown="block" class="proof"><summary>Proof</summary>

All of the expectations and the variance are taken with respect to $$P(X)$$. Let $$\mu := \E[X]$$.

$$
\begin{aligned}
\tr \Cov(X) + \|\mu-c\|_2^2
&= \sum_{i=1}^p \Var(X_i) + \|\mu-c\|_2^2 \\
&= \sum_{i=1}^p \E\left[ (X_i - \mu_i)^2 \right] + \|\mu-c\|_2^2 \\
&= \E\left[\sum_{i=1}^p (X_i - \mu_i)^2 \right] + \|\mu-c\|_2^2 \\
&= \E[(X-\mu)^T (X-\mu)] + (\mu-c)^T (\mu-c) \\
&= \E[X^T X] \underbrace{- 2 \E[X]^T \mu + \mu^T \mu + \mu^T \mu}_{=0} - 2 \mu^T c + c^T c \\
&= \E[X^T X - 2 X^T c + c^T c] \\
&= \E[\|X-c\|_2^2]
\end{aligned}
$$

</details>

We write the special case where $$X$$ and $$c$$ are scalars instead of vectors as a corollary.

**Corollary 1**: For any random variable $$X \in \R$$ and any constant $$c \in \R$$,

$$ \E[(X-c)^2] = \Var[X] + (\E[X]-c)^2. $$


# Bias and Variance of an Estimator

Consider a probability distribution $$P_T(X)$$ parameterized by $$T$$, and let $$D = \{ x^{(i)} \}_{i=1}^N$$ be a set of samples drawn i.i.d. from $$P_T(X)$$. Let $$\Th = \Th(D)$$ be an **estimator** of $$T$$ that has variability due to the randomness of the data from which it is computed.

For example, $$T$$ could be the mean of $$P_T(X)$$. The sample mean $$\Th = \frac{1}{N} \sum_{i=1}^N x^{(i)}$$ is an estimator of $$T$$.

For the rest of this section, we will use the abbreviation $$\E_T \equiv \E_{D \sim P_T(X)}$$ and similarly for variance.

The **mean squared error** of $$\Th$$ decomposes nicely into the squared-bias and variance of $$\Th$$ by a straightforward application of *Theorem 1* where $$T$$ is constant.

$$
\begin{aligned}
MSE(\Th)
&= \E_T\left[ \|\Th(D) - T\|_2^2 \right] \\
&= \| \E_T[\Th] - T \|_2^2 + \tr\Cov_T[\Th] \\
&= \|\Bias[\Th]\|_2^2 + \tr\Cov[\Th]
\end{aligned}
$$

Terminology for an estimator $$\Th$$:
- The **standard error** of a scalar estimator $$\Th$$ is $$SE(\Th) = \sqrt{\Var[\Th]}$$.
    - If $$\Th$$ is a vector, then the standard error of its $$i$$-th entry is $$SE(\Th_i) = \sqrt{\Var[\Th_i]}$$.
- $$\Th$$ is **unbiased** if $$\Bias[\Th] = 0$$.
- $$\Th$$ is **efficient** if $$\Cov[\Th]$$ equals the Cramer-Rao lower bound $$I(T)^{-1} / N$$ where $$I(T)$$ is the Fisher Information matrix of $$T$$.
    - $$\Th$$ is **_asymptotically_ efficient** if it achieves this bound asymptotically as the number of samples $$N \to \infty$$.
- $$\Th$$ is **consistent** if $$\Th \to T$$ in probability as $$N \to \infty$$.

*Sources*

- Fan, Zhou. Lecture Notes from STATS 200 course, Stanford University. Autumn 2016. [link](https://web.stanford.edu/class/archive/stats/stats200/stats200.1172/lectures.html).
- "What is the difference between a consistent estimator and an unbiased estimator?" *StackExchange*. [link](https://stats.stackexchange.com/a/31047).

## Maximum Likelihood Estimation

It can be shown that given data $$D$$ sampled i.i.d. from $$P_T(X)$$, the maximum likelihood estimator

$$
\Th_{MLE} = \argmax_\Th P_\Th(D) = \argmax_\Th \prod_{i=1}^N P_\Th(x^{(i)})
$$

is consistent and asymptotically efficient. See *Rice* 8.5.2 and 8.7.

*Sources*

- Rice, John A. *Mathematical statistics and data analysis*. 3rd ed., Cengage Learning, 2006.
    - General statistics reference. Good discussion on maximum likelihood estimation.

## Example: Variance Estimator of Gaussian Data

Consider data $$D$$ sampled i.i.d. from a univariate Gaussian distribution $$\mathcal{N}(\mu, \sigma^2)$$. Letting $$\bar{x} = \frac{1}{N} \sum_{i=1}^N x^{(i)}$$ be the sample mean, the variance of the sampled data is

$$ S_N^2 = \frac{1}{N} \sum_{i=1}^N (x^{(i)} - \bar{x})^2. $$

The estimator $$S_N^2$$ is both the method of moments estimator (*Fan*, Lecture 12) and maximum likelihood estimator (*Tobago*) of the population variance $$\sigma^2$$. Nonetheless, even though it is consistent and asymptotically efficient, it is biased (proof on [Wikipedia](https://en.wikipedia.org/wiki/Variance#Sample_variance)).

$$ \E[S_N^2] = \frac{N-1}{N} \sigma^2 \neq \sigma^2 $$

Correcting for the bias yields the usual unbiased sample variance estimator.

$$
S_{N-1}^2
= \frac{N}{N-1} S_N^2
= \frac{1}{N-1} \sum_{i=1}^N (x^{(i)} - \bar{x})^2
$$

Interestingly, although $$S_{N-1}^2$$ is an unbiased estimator of the population variance $$\sigma^2$$, its square-root $$S_{N-1}$$ is a *biased* estimator of the population standard deviation $$\sigma$$. This is because the square root is a strictly concave function, so by Jensen's inequality,

$$
\E[S_{N-1}] = \E\left[\sqrt{S_{N-1}^2}\right]
< \sqrt{\E[S_{N-1}^2]} = \sqrt{\sigma^2} = \sigma.
$$

The variances of the two estimators $$S_N^2$$ and $$S_{N-1}^2$$ are also different. The distribution of $$\frac{N-1}{\sigma^2} S_{N-1}^2$$ is $$\chi_{N-1}^2$$ (chi-square) with $$N-1$$ degrees of freedom (*Rice 6.3*), so

$$
\Var[S_{N-1}^2]
= \Var\left[ \frac{\sigma^2}{N-1} \chi_{N-1}^2 \right]
= \frac{\sigma^4}{(N-1)^2} \Var[ \chi_{N-1}^2 ]
= \frac{2 \sigma^4}{N-1}.
$$

Instead of directly calculating the variance of $$S_N^2$$, let's calculate the bias and variance of the family of estimators parameterized by $$k$$.

$$
\begin{aligned}
S_k^2
&= \frac{1}{k} \sum_{i=1}^N (x^{(i)} - \bar{x})^2
 = \frac{N-1}{k} S_{N-1}^2 \\
\E[S_k^2]
&= \frac{N-1}{k} \E[S_{N-1}^2]
 = \frac{N-1}{k} \sigma^2 \\
\Bias[S_k^2]
&= \E[S_k^2] - \sigma^2
 = \frac{N-1-k}{k} \sigma^2 \\
\Var[S_k^2]
&= \left(\frac{N-1}{k}\right)^2 \Var[S_{N-1}^2]
 = \frac{2 \sigma^4 (N-1)}{k^2} \\
MSE[S_k^2]
&= \Bias[S_k^2]^2 + \Var[S_k^2]
 = \frac{(N-1-k)^2 + 2(N-1)}{k^2} \sigma^4
\end{aligned}
$$

Although $$S_N^2$$ is biased whereas $$S_{N-1}^2$$ is not, $$S_N^2$$ actually has lower mean squared error for any sample size $$N > 2$$, as shown by the ratio of their MSEs.

$$
\frac{MSE(S_N^2)}{MSE(S_{N-1}^2)}
= \frac{\sigma^4(2N - 1) / N^2}{2 \sigma^4 / (N-1)}
= \frac{(2N-1)(N-1)}{2N^2}
$$

In fact, within the family of estimators of the form $$S_k^2$$, the estimator with the lowest mean squared error is actually $$k = N+1$$. In most real-world scenarios, though, any of $$S_{N-1}$$, $$S_N$$, and $$S_{N+1}$$ works well enough for large $$N$$.

*Sources*

- Giles, David. "Variance Estimators That Minimize MSE." *Econometrics Beat: Dave Giles' Blog*, 21 May 2013. [link](https://davegiles.blogspot.com/2013/05/variance-estimators-that-minimize-mse.html).
- Taboga, Marco. "Normal Distribution - Maximum Likelihood Estimation." *StatLect*. [link](https://www.statlect.com/fundamentals-of-statistics/normal-distribution-maximum-likelihood).
- "Variance." *Wikipedia*, 18 July 2019. [link](https://en.wikipedia.org/wiki/Variance).

## Example: Linear Regression

In the setting of parameter estimation for linear regression, the task is to estimate the coefficients $$w \in \R^p$$ that relate a scalar output $$Y$$ to a vector of regressors $$X \in \R^p$$. It is typically assumed that $$Y$$ and $$X$$ are random variables related by $$ Y = w^T X + \epsilon $$ for some noise $$\epsilon \in \R$$. However, we will take the unusual step of not necessarily assuming that the relationship between $$X$$ and $$Y$$ is truly linear, but instead that their relationship is given by $$Y = f(X) + \epsilon$$ for some arbitrary function $$f: \R^p \to \R$$.

Suppose that the noise $$\epsilon \sim \Noise$$ is independent of $$X$$ and that $$\Noise$$ is some arbitrary distribution with mean 0 and constant variance $$\sigma^2$$. One example of such a noise distribution is $$\epsilon \sim \mathcal{N}(0, \sigma^2)$$, although our following analysis does not require a Gaussian distribution.

Thus, for a given $$x$$,

$$
\begin{aligned}
\E_{y \sim P(Y|X=x)}[y] &= f(x) \\
\Var_{y \sim P(Y|X=x)}[y] &= \Var_{\epsilon \sim \Noise}[\epsilon] = \sigma^2
\end{aligned}
$$

Note that if $$\sigma^2 = 0$$, then $$Y$$ is deterministically related to $$X$$, *i.e.* $$Y = f(X)$$.

We aim to estimate a linear regression function $$\fh$$ that approximates the true $$f$$ over some given training set of $$N$$ labeled examples $$D = \left\{ \left(x^{(i)}, y^{(i)} \right) \right\}_{i=1}^N$$ sampled from an underlying joint distribution $$P(X,Y)$$. In matrix notation, we can write $$D = (\Xbf, \ybf)$$ where $$\Xbf \in \R^{N \times p}$$ and $$\ybf \in \R^N$$ have the training examples arranged in rows.

We can factor $$P(X,Y) = P(Y \mid X) P(X)$$. We have assumed that $$P(Y \mid X)$$ has mean $$f(X)$$ and variance $$\sigma^2$$. However, we do not assume anything about the marginal distribution $$P(X)$$ of the inputs, which is arbitrary depending on the dataset.

For the rest of this post, we use the following abbreviations for the subscripts of expectations and variances:

$$
\begin{aligned}
\epsilon &\equiv \epsilon \sim \Noise \\
y \mid x &\equiv y \sim p(Y \mid X=x) \\
\ybf \mid \Xbf &\equiv \ybf \sim p(Y \mid X=\Xbf) \\
x &\equiv x \sim P(X) \\
D &\equiv D \sim P(X, Y)
\end{aligned}
$$

and the following shorthand notations:

$$
\begin{aligned}
\Zbf_\Xbf &= (\Xbf^T \Xbf)^{-1} \Xbf^T \in \R^{p \times N} \\
\Zbf_{\Xbf, \alpha} &= (\Xbf^T \Xbf + \alpha I_d)^{-1} \Xbf^T \in \R^{p \times N} \\
\wh_{\Xbf, f} &= \Zbf_\Xbf f(\Xbf) = (\Xbf^T \Xbf)^{-1} \Xbf^T f(\Xbf) \in \R^p \\
\wh_{\Xbf, f, \alpha} &= \Zbf_{\Xbf, \alpha} f(\Xbf) = (\Xbf^T \Xbf + \alpha I_d)^{-1} \Xbf^T f(\Xbf) \in \R^p \\
\hbf_\Xbf(x) &= \Zbf_\Xbf^T x = \Xbf (\Xbf^T \Xbf)^{-1} x \in \R^N \\
\hbf_{\Xbf, \alpha}(x) &= \Zbf_{\Xbf, \alpha}^T x = \Xbf (\Xbf^T \Xbf + \alpha I_d)^{-1} x \in \R^N.
\end{aligned}
$$

### Main Results

The ordinary least-squares (OLS) and ridge regression estimators for $$w$$ are

$$
\begin{aligned}
\wh
&= \argmin_w \| f(\Xbf) - \Xbf w \|^2
 = (\Xbf^T \Xbf)^{-1} \Xbf^T \ybf \\
\whR
&= \argmin_w \| f(\Xbf) - \Xbf w \|^2 + \alpha \|w\|_2^2
 = (\Xbf^T \Xbf + \alpha I_d)^{-1} \Xbf^T \ybf.
\end{aligned}
$$

Their bias and variance properties are summarized in the table below. Note that in the case of arbitrary $$f$$, the bias of an estimator is technically undefined, since there is no "true" value to compare it to. (See highlighted cells in the table.) Instead, we compare our estimators to the parameters $$w_\star$$ of the best-fitting linear approximation to the true $$f$$. When $$f$$ is truly linear, *i.e.* $$f(x) = w^T x$$, then $$w_\star = w$$. The derivation for $$w_\star$$ can be found [here](https://stats.stackexchange.com/a/247021).

$$
\begin{aligned}
w_\star
&= \argmin_w \E_x\left[ (f(x) - w^T x)^2 \right] \\
&= \E_x[x x^T]^{-1} \E_x[x f(x)]. \\
\end{aligned}
$$

We separately consider 2 cases:

- The training inputs $$\Xbf$$ are fixed, and the training targets are sampled from the conditional distribution $$\ybf \sim P(Y \mid X=\Xbf)$$.
- Both the training inputs and targets are sampled jointly $$(\Xbf, \ybf) \sim P(X, Y)$$.

We also show that the variance of the ridge regression estimator is strictly less than the variance of the linear regression estimator when $$\Xbf$$ are considered fixed. Furthermore, there always exists some choice of $$\alpha$$ such that the mean squared error of $$\whR$$ is less than the mean squared error of $$\wh$$.

<table class="text-center">
  <tr>
    <th colspan="2"></th>
    <th colspan="2" markdown="span">arbitrary $$f(X)$$</th>
    <th colspan="2" markdown="span">linear $$f(X)$$</th>
  </tr>
  <tr>
    <th colspan="2"></th>
    <th markdown="span">fixed $$\Xbf$$</th>
    <th markdown="span">$$\E_D$$</th>
    <th markdown="span">fixed $$\Xbf$$</th>
    <th markdown="span">$$\E_D$$</th>
  </tr>
  <tr>
    <td rowspan="2">OLS</td>
    <td>Bias</td>
    <td markdown="span" style="background-color: beige;">0</td>
    <td markdown="span" style="background-color: beige;">$$\E_\Xbf[ \wh_{\Xbf, f} ] - w_\star$$</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Variance</td>
    <td markdown="span">$$\sigma^2 (\Xbf^T \Xbf)^{-1}$$</td>
    <td markdown="span">$$\Cov_\Xbf[\wh_{\Xbf, f}] + \sigma^2 \E_\Xbf\left[(\Xbf^T \Xbf)^{-1}\right]$$</td>
    <td markdown="span">$$\sigma^2 (\Xbf^T \Xbf)^{-1}$$</td>
    <td markdown="span">$$\sigma^2 \E_\Xbf\left[(\Xbf^T \Xbf)^{-1}\right]$$</td>
  </tr>
  <tr>
    <td rowspan="2">Ridge Regression</td>
    <td>Bias</td>
    <td markdown="span" style="background-color: beige;">$$\Zbf_{\Xbf, \alpha} \Xbf w_\star - w_\star$$</td>
    <td markdown="span" style="background-color: beige;">$$\E_\Xbf\left[ \Zbf_{\Xbf, \alpha} \Xbf \right] w_\star - w_\star$$</td>
    <td markdown="span">$$\wh_{\Xbf, f, \alpha} - w$$</td>
    <td markdown="span">$$\E_\Xbf\left[ \wh_{\Xbf, f, \alpha} \right] - w$$</td>
  </tr>
  <tr>
    <td>Variance</td>
    <td markdown="span">$$\sigma^2 \Zbf_{\Xbf, \alpha} \Zbf_{\Xbf, \alpha}^T$$</td>
    <td markdown="span">$$\Cov_\Xbf[ \wh_{\Xbf, f, \alpha} ] + \sigma^2 \E_{\Xbf, \epsilon}[\Zbf_{\Xbf, \alpha} \Zbf_{\Xbf, \alpha}^T]$$</td>
    <td markdown="span">$$\sigma^2 \Zbf_{\Xbf, \alpha} \Zbf_{\Xbf, \alpha}^T$$</td>
    <td markdown="span">$$\Cov_\Xbf[ \wh_{\Xbf, f, \alpha} ] + \sigma^2 \E_{\Xbf, \epsilon}[\Zbf_{\Xbf, \alpha} \Zbf_{\Xbf, \alpha}^T]$$</td>
  </tr>
</table>

**Linear Regression Estimator for arbitrary $$f$$**

<details markdown="block" class="proof"><summary>Details</summary>

First, we consider the case where the training inputs $$\Xbf$$ are fixed. In this case, the estimator $$\wh$$ is unbiased relative to $$w_\star$$.

$$
\begin{aligned}
\E_{\ybf|\Xbf}[\wh]
&= \E_{\ybf|\Xbf}\left[ (\Xbf^T \Xbf)^{-1} \Xbf^T \ybf \right] \\
&= (\Xbf^T \Xbf)^{-1} \Xbf^T \E_{\ybf|\Xbf}[\ybf] \\
&= (\Xbf^T \Xbf)^{-1} \Xbf^T f(\Xbf)
 = \wh_{\Xbf, f} \\
&= n (\Xbf^T \Xbf)^{-1} \cdot \frac{1}{n} \Xbf^T f(\Xbf) \\
&= \left( \frac{1}{n} \sum_{i=1}^N x^{(i)} x^{(i)T} \right)^{-1} \frac{1}{n} \sum_{i=1}^N x^{(i)} f(x^{(i)}) \\
&= \E_x[x x^T]^{-1} \E_x[x f(x)]
 = w_\star
\\
\Cov[\wh \mid \Xbf]
&= \Cov_{\ybf | \Xbf} [ \wh ] \\
&= \Cov_{\ybf | \Xbf} \left[ (\Xbf^T \Xbf)^{-1} \Xbf^T \ybf \right] \\
&= \Zbf \Cov_{\ybf | \Xbf}[\ybf] \Zbf^T \\
&= \Zbf (\sigma^2 I_n) \Zbf^T \\
&= \sigma^2 \Zbf \Zbf^T \\
&= \sigma^2 (\Xbf^T \Xbf)^{-1}
\end{aligned}
$$

However, if the training inputs $$\Xbf$$ are sampled randomly, then the estimator is no longer unbiased, and the variance term also becomes dependent on $$f$$.

$$
\begin{aligned}
\E_D[\wh]
&= \E_\Xbf \left[ \E_{\ybf|\Xbf}[ \wh ] \right]
 = \E_\Xbf[ \wh_{\Xbf, f} ]
\\
\Bias[\wh]
&= \E_\Xbf[ \wh_{\Xbf, f} ] - w_\star
\end{aligned}
$$

We prove by counterexample that $$\E_\Xbf[ \wh_{\Xbf, f} ] \neq w_\star$$. Suppose $$X \sim \mathsf{Uniform}[0, 1]$$ is a scalar random variable, let $$f(x) = x^2$$, and consider a training set of size 2: $$D = \{a, b\} \sim P(X)$$. We evaluate the integral by [WolframAlpha](https://www.wolframalpha.com/input/?i=integrate+(a%5E3+%2B+b%5E3)%2F(a%5E2+%2B+b%5E2)+from+b%3D0+to+1+and+a%3D0+to+1). Otherwise, we can also compute the integral manually by splitting the fraction and doing a $$u$$-substitution with $$u = a^2$$.

$$
\begin{aligned}
w_\star
&= \E_x[x x^T]^{-1} \E_x[x f(x)] \\
&= \E_x[x^2]^{-1} \E_x[x^3] \\
&= (1/3)^{-1} (1/4) = 3/4
\\
\E_D[\wh]
&= \E_\Xbf\left[ (\Xbf^T \Xbf)^{-1} \Xbf^T f(\Xbf) \right] \\
&= \E_{a, b \sim P(X)} \left[ (a^2 + b^2)^{-1} (a^3 + b^3) \right] \\
&= \int_0^1 \int_0^1 \frac{a^3 + b^3}{a^2 + b^2} \ da \ db \\
&= \frac{1}{6} \left( 2 + \pi - \ln 4 \right)
 \approx 0.63
\end{aligned}
$$

The derivation for the variance of $$\wh$$ relies heavily on the linearity of expectation for matrices (see [Appendix](#appendix)).

$$
\begin{aligned}
\Cov[\wh]
&= \Cov_D[ \wh ] \\
&= \Cov_{\Xbf, \epsilon} [ (\Xbf^T \Xbf)^{-1} \Xbf^T (f(\Xbf) + \epsilon) ] \\
&= \Cov_{\Xbf, \epsilon} [ \wh_{\Xbf, f} + \Zbf_\Xbf \epsilon ] \\
&= \E_{\Xbf, \epsilon} [ (\wh_{\Xbf, f} + \Zbf_\Xbf \epsilon) (\wh_{\Xbf, f} + \Zbf_\Xbf \epsilon)^T ] - \E_{\Xbf, \epsilon}[ \wh_{\Xbf, f} + \Zbf_\Xbf \epsilon ] \E_{\Xbf, \epsilon}[ \wh_{\Xbf, f} + \Zbf_\Xbf \epsilon ]^T \\
&= \E_{\Xbf, \epsilon} \left[ \wh_{\Xbf, f} \wh_{\Xbf, f}^T + \wh_{\Xbf, f} (\Zbf_\Xbf \epsilon)^T + \Zbf_\Xbf \epsilon \wh_{\Xbf, f}^T + \Zbf_\Xbf \epsilon (\Zbf_\Xbf \epsilon)^T \right] - \E_\Xbf[\wh_{\Xbf, f}] \E_\Xbf[\wh_{\Xbf, f}]^T \\
&= \E_\Xbf[ \wh_{\Xbf, f} \wh_{\Xbf, f}^T ] + 0 + 0 + \E_{\Xbf, \epsilon}[\Zbf_\Xbf \epsilon \epsilon^T \Zbf_\Xbf^T] - \E_\Xbf[\wh_{\Xbf, f}] \E_\Xbf[\wh_{\Xbf, f}]^T \\
&= \Cov_\Xbf[\wh_{\Xbf, f}] + \E_\Xbf\left[\Zbf_\Xbf \underbrace{\E_\epsilon[\epsilon \epsilon^T]}_{=\sigma^2 I_N} \Zbf_\Xbf^T\right] \\
&= \Cov_\Xbf[\wh_{\Xbf, f}] + \sigma^2 \E_\Xbf\left[(\Xbf^T \Xbf)^{-1}\right]
\end{aligned}
$$

</details>

**Linear Regression Estimator for linear $$f$$**

In this setting, we assume that $$f(x) = w^T x$$ for some true $$w$$. As a special case, if the noise is Gaussian distributed $$\epsilon \sim \mathcal{N}(0, \sigma^2)$$, then $$\wh$$ is the maximum likelihood estimator (MLE) for $$w$$, so it is consistent and asymptotically efficient.

<details markdown="block" class="proof"><summary>Details</summary>

If $$\Xbf$$ is fixed, then the least-squares estimate is unbiased.

$$
\begin{aligned}
\Bias[\wh \mid \Xbf]
&= \E_{\ybf \mid \Xbf}[\wh] - w \\
&= \wh_{\Xbf, f} - w \\
&= (\Xbf^T \Xbf)^{-1} \Xbf^T \Xbf w - w \\
&= 0.
\end{aligned}
$$

Therefore, the expectation of the bias over the distribution of $$\Xbf$$ is also 0.

If $$\Xbf$$ is fixed, then variance of the least-squares estimate is the same for linear or nonlinear $$f$$, since it does not depend on $$f$$.

However, when the training inputs $$\Xbf$$ are sampled randomly, the variance does depend on $$f$$. Subsitituting $$f(\Xbf) = \Xbf w$$ into the variance expression derived for arbitrary $$f$$ yields

$$
\begin{aligned}
\Cov_\Xbf[\wh_{\Xbf, f}]
&= \Cov_\Xbf[(\Xbf^T \Xbf)^{-1} \Xbf^T f(\Xbf)] \\
&= \Cov_\Xbf[(\Xbf^T \Xbf)^{-1} \Xbf^T (\Xbf w)] \\
&= \Cov_\Xbf[w] = 0
\end{aligned}
$$

so $$\Cov[\wh] = \sigma^2 \E_\Xbf\left[ (\Xbf^T \Xbf)^{-1} \right]$$.

</details>


**Ridge Regression Estimator**

The ridge regression estimator $$\whR$$ is a linear function of the least-squares estimator $$\wh$$.

$$
\begin{aligned}
\whR
&= (\Xbf^T \Xbf + \alpha I_d)^{-1} \Xbf^T \ybf \\
&= (\Xbf^T \Xbf + \alpha I_d)^{-1} \underbrace{(\Xbf^T \Xbf) (\Xbf^T \Xbf)^{-1}}_{=I_d} \Xbf^T \ybf \\
&= (\Xbf^T \Xbf + \alpha I_d)^{-1} (\Xbf^T \Xbf) \wh \\
&= \Zbf_{\Xbf, \alpha} \Xbf \wh
\end{aligned}
$$

<details markdown="block" class="proof"><summary>Details</summary>

If $$f$$ is arbitrary and $$\Xbf$$ is fixed, then the expectation of the ridge regression estimator is not equal to $$w_\star$$, so it is biased. The inequality on the first line comes from the fact that $$\Zbf_{\Xbf, \alpha} \Xbf = (\Xbf^T \Xbf + \alpha I_d)^{-1} (\Xbf^T \Xbf) \neq I_d$$.

$$
\begin{aligned}
\E_{\ybf|\Xbf}[\whR]
&= \E_{\ybf|\Xbf}[\Zbf_{\Xbf, \alpha} \Xbf \wh]
 = \Zbf_{\Xbf, \alpha} \Xbf \E_{\ybf|\Xbf}[\wh]
 = \Zbf_{\Xbf, \alpha} \Xbf w_\star
 \neq w_\star \\
\Bias[\whR \mid \Xbf]
&= \E_{\ybf \mid \Xbf}[\whR] - w_\star
 = \Zbf_{\Xbf, \alpha} \Xbf w_\star - w_\star \\
\Cov_{\ybf|\Xbf}[\whR \mid \Xbf]
&= \Cov_{\ybf|\Xbf}\left[ \Zbf_{\Xbf, \alpha} \Xbf \wh \right] \\
&= \Zbf_{\Xbf, \alpha} \Xbf \Cov_{\ybf|\Xbf}\left[ \wh \right] \Xbf^T \Zbf_{\Xbf, \alpha}^T \\
&= \sigma^2 \Zbf_{\Xbf, \alpha} \Xbf (\Xbf^T \Xbf)^{-1} \Xbf^T \Zbf_{\Xbf, \alpha}^T \\
&= \sigma^2 \Zbf_{\Xbf, \alpha} \Zbf_{\Xbf, \alpha}^T
\end{aligned}
$$

If $$f$$ was truly linear so $$w_\star = w$$ and $$f(\Xbf) = \Xbf w$$, then we can simplify the bias. However, the variance expression does not depend on $$f$$, so it is the same regardless of whether $$f$$ is linear or not.

$$
    \Bias[\whR \mid \Xbf]
    = \Zbf_{\Xbf, \alpha} \Xbf w - w
    = \Zbf_{\Xbf, \alpha} f(\Xbf) - w
    = \wh_{\Xbf, f, \alpha} - w.
$$

If the training inputs $$\Xbf$$ are sampled randomly with arbitrary $$f$$, then the bias and variance are as follows. The variance derivation follows a similar proof to the ordinary linear regression.

$$
\begin{aligned}
\E_D[\whR]
&= \E_\Xbf\left[ \E_{\ybf \mid \Xbf}[\whR] \right]
 = \E_\Xbf\left[ \Zbf_{\Xbf, \alpha} \Xbf \right] w_\star \\
\Bias[\whR]
&= \E_\Xbf\left[ \Zbf_{\Xbf, \alpha} \Xbf \right] w_\star - w_\star \\
\Cov[\whR]
&= \Cov_{\Xbf, \epsilon}\left[ \wh_{\Xbf, f, \alpha} + \Zbf_{\Xbf, \alpha} \epsilon \right] \\
&= \E_\Xbf[ \wh_{\Xbf, f, \alpha} \wh_{\Xbf, f, \alpha}^T ] + \E_{\Xbf, \epsilon}[\Zbf_{\Xbf, \alpha} \epsilon \epsilon^T \Zbf_{\Xbf, \alpha}^T] - \E_\Xbf[\wh_{\Xbf, f, \alpha}] \E_\Xbf[\wh_{\Xbf, f, \alpha}]^T \\
&= \Cov_\Xbf[ \wh_{\Xbf, f, \alpha} ] + \sigma^2 \E_{\Xbf, \epsilon}[\Zbf_{\Xbf, \alpha} \Zbf_{\Xbf, \alpha}^T].
\end{aligned}
$$

If $$f$$ is truly linear, then $$\Bias[\whR] = \E_\Xbf\left[ \wh_{\Xbf, f, \alpha} \right] - w$$.

</details>

### Comparing linear regression and ridge regression estimators

For any $$\alpha > 0$$ and assuming the training inputs $$\Xbf$$ are fixed and full-rank, the ridge regression estimator has lower variance than the standard linear regression estimator without regularization. This result holds regardless of whether $$f$$ is linear or not.

Because the estimators $$\wh$$ and $$\whR$$ are vectors, their variances are really covariance matrices. Thus, when we compare their variances, we actually compare the definiteness of their covariance matrices. One way to see this is that the MSE formula only depends on the trace of the covariance matrix. For any two vectors $$a$$ and $$b$$,

$$
\Cov[a] - \Cov[b] \succ 0
\quad\implies\quad \tr(\Cov[a] - \Cov[b]) > 0
\quad\iff\quad \tr(\Cov[a]) > \tr(\Cov[b]).
$$

The first implication relies on the fact that if a matrix is positive definite, its trace is positive. Thus, showing that $$\Cov[\wh \mid \Xbf] \succ \Cov[\whR \mid \Xbf]$$ establishes that the $$\wh$$ has a larger variance term in its MSE decomposition.

For linear models, comparing the definiteness of the covariance matrices is also directly related to the variance of the predicted outputs. This makes more sense when we discuss the variance of the ridge regression *predictor* later in this post.

**Theorem**: If we take the training inputs $$\Xbf \in \R^{n \times d}$$ with $$n \geq d$$ to be fixed and full-rank while the training labels $$\ybf \in \R^N$$ have variance $$\sigma^2$$, then the variance of any ridge regression estimator with $$\alpha > 0$$ has lower variance than the standard linear regression estimator without regularization. In other words, $$\forall \alpha > 0.\, \Cov[\whR \mid \Xbf] \prec \Cov[\wh \mid \Xbf]$$.

<details markdown="block" class="proof"><summary>Proof</summary>

Let $$S = \Xbf^T \Xbf$$ and $$W = (\Xbf^T \Xbf + \alpha I)^{-1}$$. Both $$S$$ and $$W$$ are symmetric and invertible matrices. Note that $$S \succ 0$$ because $$z^T S z = \| \Xbf z \|_2^2 > 0$$ for all non-zero $$z$$ (since $$\Xbf$$ has linearly independent columns). Then, $$W^{-1} = (S + \alpha I) \succ 0$$ because $$I \succ 0$$ and $$\alpha > 0$$. Since the inverse of any positive definite matrix is also positive definite, $$S^{-1} \succ 0$$ and $$W \succ 0$$ as well.

$$
\begin{aligned}
\Cov[\whR \mid \Xbf]
&= \sigma^2 \Zbf_{\Xbf, \alpha} \Zbf_{\Xbf, \alpha}^T
 = \sigma^2 W \Xbf^T \Xbf^T W
 = \sigma^2 WSW \\
\Cov[\wh \mid \Xbf]
&= \sigma^2 (\Xbf^T \Xbf)^{-1}
 = \sigma^2 S^{-1} \\
\Cov[\wh \mid \Xbf] - \Cov[\whR \mid \Xbf]
&= \sigma^2 (S^{-1} - WSW)
\end{aligned}
$$

We will show that $$S^{-1} - WSW \succ 0$$ (positive definite), which implies that $$\Cov[\whR \mid \Xbf] \prec \Cov[\wh \mid \Xbf]$$.

We first show

$$
\begin{aligned}
W^{-1} S^{-1} W^{-1} - S
&= (S + \alpha I) S^{-1} (S + \alpha I) - S \\
&= (I + \alpha S^{-1}) (S + \alpha I) - S \\
&= 2 \alpha I + \alpha^2 S^{-1}
\end{aligned}
$$

which is clearly positive definite since $$I \succ 0$$, $$S^{-1} \succ 0$$, and $$\alpha > 0$$.

We can then expand

$$
\begin{aligned}
S^{-1} - WSW
&= W W^{-1} S^{-1} W^{-1} W - WSW \\
&= W (W^{-1} S^{-1} W^{-1} - S) W \\
&= \alpha W (2I + \alpha S^{-1}) W
\end{aligned}
$$

which is positive definite. This is because $$ z^T W (2I + \alpha S^{-1}) W z > 0 $$ for all $$Wz \neq 0$$ (since the matrix inside the parentheses is positive definite), and $$W$$ is invertible so $$Wz \neq 0 \iff z \neq 0$$.

</details>

Having shown that the ridge regression estimator is biased but has lower variance than the unbiased least-squares estimator, the obvious next question is whether the decrease in variance is greater than the bias. Indeed, the following theorem shows that the ridge regression estimator is always able to achieve lower mean squared error.

**Theorem**: Assume that the training inputs $$\Xbf$$ are fixed and that $$f(x) = w^T x$$ is truly linear. Then $$MSE[\whR] < MSE[\wh]$$ if and only if $$ 0 < \alpha < 2 \frac{\sigma^2}{\|w\|_2^2}$$.

As the proof for this is quite involved, we refer readers to Theorem 1.2 of *Wieringen, 2015* or Theorem 4.3 of *Hoerl and Kennard, 1970* for different proofs of this theorem.

*Sources*

- Hoerl, Arthur E., and Robert W. Kennard. "Ridge regression: Biased estimation for nonorthogonal problems." *Technometrics* 12.1 (1970): 55-67. [link](https://www.tandfonline.com/doi/abs/10.1080/00401706.1970.10488634).
    - Proves that the MSE of ridge regression estimator is less than the MSE of the least-squares estimator for certain values of $$\alpha$$.
- "Prove that the variance of the ridge regression estimator is less than the variance of the OLS estimator." *StackExchange*. [link](https://stats.stackexchange.com/a/247021).
- Taboga, Marco. "Ridge Regression." *StatLect*. [link](https://www.statlect.com/fundamentals-of-statistics/ridge-regression).
    - Provides alternative proof for why the ridge regression estimator has lower variance than the ordinary linear regression estimator.
- van Wieringen, Wessel N. "Lecture notes on ridge regression." *arXiv preprint arXiv:1509.09169* (2018). [link](https://arxiv.org/abs/1509.09169).
    - Reference for bias and variance of linear and ridge regression estimators.
    - Only discusses the case where training inputs are fixed.


# Bias and Variance of a Predictor (or Model)

## Setup

We consider the same setup discussed in the Linear Regression section above. To recap, we have 3 random variables $$X \in \R^p$$, $$Y \in \R$$, and $$\epsilon \in \R$$, related by $$ Y = f(X) + \epsilon $$ for some function $$f: \R^p \to \R$$. The *noise* $$\epsilon \sim \Noise$$ is independent of $$X$$ and is distributed with mean 0 and variance $$\sigma^2$$.

## Decomposition

The bias-variance decomposition of mean squared error is a method for analyzing a deterministic model's behavior when trained on different training sets drawn from the same underlying distribution. To do this, we fix some test point $$x$$ and then iterate the following procedure many times:

1. Sample $$y \sim p(Y \mid X=x)$$. Equivalently, sample $$\epsilon \sim \Noise$$, then set $$y = f(x) + \epsilon$$.
2. Sample a training set $$D$$ from $$P(X,Y)$$.
3. Fit $$\fh_D$$ to the training set.
4. Predict $$\fh_D(x)$$ as our estimate of $$y$$.

The **mean squared error** of our model $$\fh_D$$ on a particular test point $$x$$ is then

$$
\begin{aligned}
MSE(x)
&= \E_{y|x} \left[ \E_D \left[ (y - \fh_D(x))^2 \right] \right] \\
&= (\Bias[\fh(x)])^2 + \Var[\fh(x)] + \text{Noise}
\end{aligned}
$$

where

$$
\begin{aligned}
\Bias[\fh(x)] &= \E_D[\fh_D(x)] - f(x) \\
\Var[\fh(x)] &= \Var_D[\fh_D(x)] \\
\text{Noise} &= \sigma^2.
\end{aligned}
$$

<details markdown="block" class="proof"><summary>Proof</summary>

$$
\begin{aligned}
MSE(x)
&= \E_{y|x} \left[ \E_D [ (y - \fh_D(x))^2 ] \right] \\
&= \E_{y|x} \left[ \Var_D[\fh_D(x)] + \left(\E_D[\fh_D(x)] - y\right)^2 \right] \\
&= \Var_D[\fh_D(x)] + \E_{y|x} \left[ \left(\E_D[\fh_D(x)] - y\right)^2 \right] \\
&= \Var_D[\fh_D(x)] + \Var_{p(y|x)}[y] + \left( \E_D[\fh_D(x)] - \E_{y|x}[y] \right)^2 \\
&= \Var_D[\fh_D(x)] + \sigma^2 + \left( \E_D[\fh_D(x)] - f(x) \right)^2 \\
&= \Var[\fh(x)] + \text{Noise} + (\Bias[\fh(x)])^2
\end{aligned}
$$

The 2nd equality comes from applying *Corollary 1* where $$y$$ is constant w.r.t. $$D$$. The 4th equality comes again from applying *Corollary 1*, but this time $$\E_D[\fh_D(x)]$$ is constant w.r.t. $$y$$.

</details>

Thus we have decomposed the mean squared error into 3 terms: **bias**, **variance**, and **noise**. Notice that if there is no noise ($$\sigma^2 = 0$$), then the mean squared error decomposes strictly into bias and variance. The mean squared error at $$x$$ is also known as **expected prediction error** at $$x$$, commonly written as $$EPE(x)$$.

## Discussion

The noise term $$\sigma^2$$, also known as *irreducible error* or *aleatoric uncertainty*, is the variance of the target $$Y$$ around its true mean $$f(x)$$. It is inherent in the problem and it does not depend on the model or training data. If the data generation process is known, then we may know $$\sigma^2$$. Otherwise, we may estimate $$\sigma^2$$ with the sample variance of $$y$$ at duplicated (or nearby) inputs $$x$$.

However, the bias and variance components do depend on the model. A misspecified model, *i.e.* a model that does not match the true distribution of the data, will generally have bias. Thus, a model with high bias may *underfit* the data. On the other hand, more complex models have lower bias but higher variance. Such models have a tendency to *overfit* the data. In many circumstances it is possible to achieve large reductions in the variance term $$\Var_D [ \fh_D(x) ]$$ with only a small increase in bias, thus reducing overfitting. We show this explicitly in the setting of linear models by comparing linear regression with ridge regression.

In general, we are unable to exactly calculate the bias and variance of a learned model without knowing the true $$f$$. However, we can estimate the bias, variance, and MSE at a test point $$x$$ by taking bootstrap samples of the dataset to approximate drawing different datasets $$D$$.

## Example: Linear Regression and Ridge Regression

Consider a linear model $$\fh(x) = \wh^T x$$ over $$p$$-dimensional inputs $$x \in \R^p$$, where the intercept is included in $$\wh$$. The relationship between the bias/variance of an estimator and the bias/variance of the model is straightforward for a linear model. Thus, we can readily use the results derived for the bias and variance of linear and ridge regression estimators.

$$
\begin{aligned}
\Bias[\fh(x)]
&= \E_D[\fh_D(x)] - f(x) \\
&= \E_D[\wh_D^T x] - w^T x \\
&= \left(\E_D[\wh_D] - w \right)^T x \\
&= \Bias[\wh]^T x
\\
\Var[\fh(x)]
&= \Var_D[ \fh_D(x) ] \\
&= \Var_D[ x^T \wh_D ] \\
&= x^T \Cov_D[ \wh_D ]\ x
\end{aligned}
$$

However, when $$f$$ is arbitrary, we cannot use the estimator bias results directly because they were derived relative to $$w_\star$$. Here, we are interested in the bias of $$\wh^T x$$ vs. $$f(x)$$, as opposed to $$w_\star^T x$$.

As before, we separately consider the cases where the true $$f$$ is an arbitrary function and when $$f$$ is perfectly linear in $$x$$. We also consider whether or not the training inputs $$\Xbf$$ are fixed. The training targets $$\ybf$$ are always sampled from $$P(Y \mid X)$$.

### Main Results

<table class="text-center">
  <tr>
    <th colspan="2"></th>
    <th colspan="2" markdown="span">arbitrary $$f(X)$$</th>
    <th colspan="2" markdown="span">linear $$f(X)$$</th>
  </tr>
  <tr>
    <th colspan="2"></th>
    <th markdown="span">fixed $$\Xbf$$</th>
    <th markdown="span">$$\E_D$$</th>
    <th markdown="span">fixed $$\Xbf$$</th>
    <th markdown="span">$$\E_D$$</th>
  </tr>
  <tr>
    <td rowspan="2">OLS</td>
    <td>Bias</td>
    <td markdown="span">$$x^T \wh_{\Xbf, f} - f(x)$$</td>
    <td markdown="span">$$x^T \E_\Xbf[\wh_{\Xbf, f}] - f(x)$$</td>
    <td>0</td>
    <td>0</td>
  </tr>
  <tr>
    <td>Variance</td>
    <td markdown="span">$$\sigma^2 \|\hbf_\Xbf(x)\|_2^2$$</td>
    <td markdown="span">$$x^T \Cov_\Xbf[\wh_{\Xbf, f}] x + \sigma^2 \E_\Xbf\left[ \|\hbf_\Xbf(x)\|_2^2 \right]$$</td>
    <td markdown="span">$$\sigma^2 \|\hbf_\Xbf(x)\|_2^2$$</td>
    <td markdown="span">$$\sigma^2 \E_\Xbf\left[ \|\hbf_\Xbf(x)\|_2^2 \right]$$</td>
  </tr>
  <tr>
    <td rowspan="2">Ridge Regression</td>
    <td>Bias</td>
    <td markdown="span">$$\Zbf_{\Xbf, \alpha} \Xbf w_\star^T x - w_\star^T x$$</td>
    <td markdown="span">$$\E_\Xbf\left[ \Zbf_{\Xbf, \alpha} \Xbf \right] w_\star^T x - w_\star^T x$$</td>
    <td markdown="span">$$\wh_{\Xbf, f, \alpha}^T x - w^T x$$</td>
    <td markdown="span">$$\E_\Xbf\left[ \wh_{\Xbf, f, \alpha} \right]^T x - w^T x$$</td>
  </tr>
  <tr>
    <td>Variance</td>
    <td markdown="span">$$\sigma^2 \|\hbf_{\Xbf, \alpha}(x)\|_2^2$$</td>
    <td markdown="span">$$x^T \Cov_\Xbf[\wh_{\Xbf, \alpha, f}] x + \sigma^2 \E_\Xbf\left[ \|\hbf_{\Xbf, \alpha}(x)\|_2^2 \right]$$</td>
    <td markdown="span">$$\sigma^2 \|\hbf_{\Xbf, \alpha}(x)\|_2^2$$</td>
    <td markdown="span">$$x^T \Cov_\Xbf[\wh_{\Xbf, \alpha, f}] x + \sigma^2 \E_\Xbf\left[ \|\hbf_{\Xbf, \alpha}(x)\|_2^2 \right]$$</td>
  </tr>
</table>

### Decomposing Bias for Linear Models

Before discussing the bias and variance of the linear and ridge regression models, we take a brief digression to show a further decomposition of bias for linear models. While there may exist similar decompositions for other model families, the following decomposition explicitly assumes that our model $$\fh(x)$$ is linear.

Let $$w_\star = \argmin_w \E_{x \sim P(X)}\left[ (f(x) - w^T x)^2 \right]$$ be the parameters of the best-fitting linear approximation to the true $$f$$, which may or may not be linear. Then, the expected squared bias term decomposes into **model bias** and **estimation bias**.

$$
\begin{aligned}
\E_x\left[ (\Bias[\fh(x)])^2 \right]
&= \E_x\left[ \left( \E_D[\fh_D(x)] - f(x) \right)^2 \right] \\
&= \E_x\left[ \left( w_\star^T x - f(x) \right)^2 \right] + \E_x\left[ \left( \E_D[\wh_D^T x] - w_\star^T x \right)^2 \right] \\
&= \mathrm{Average}[(\text{Model Bias})^2] + \mathrm{Average}[(\text{Estimation Bias})^2]
\end{aligned}
$$

The **model bias** is the error between the best-fitting linear approximation $$w_\star^T x$$ and the true function $$f(x)$$. Note that $$w_\star$$ is exactly defined as the parameters of a linear model that minimizes the average squared model bias. If $$f$$ is not perfectly linear, then the squared model bias is clearly positive. The **estimation bias** is the error between the average estimate $$\E_D[\wh_D^T x]$$ and the best-fitting linear approximation $$w_\star^T x$$.

For example, if the true function was quadratic, then there would be a large model bias. However, if $$f$$ is linear, then the model bias is 0; in fact, both the model bias and the estimation bias are 0 at all test points $$x$$, as shown in the next section. On the other hand, ridge regression has positive estimation bias, but reduced variance.

<details markdown="block" class="proof"><summary>Proof</summary>

For any arbitrary $$\wh$$,

$$
\begin{aligned}
\left( f(x) - \wh^T x \right)^2
&= \left( f(x) - w_\star^T x + w_\star^T x - \wh^T x \right)^2 \\
&= \left( f(x) - w_\star^T x \right)^2 + \left( w_\star^T x - \wh^T x \right)^2 + 2 \left( f(x) - w_\star^T x \right)\left( w_\star^T x - \wh^T x \right).
\end{aligned}
$$

The expected value of the 3rd term (with respect to $$x$$) is 0.

$$
\begin{aligned}
&\E_x\left[ \left( f(x) - w_\star^T x \right)\left( w_\star^T x - \wh^T x \right) \right] \\
&= \E_x\left[ ( f(x) - w_\star^T x) x^T (w_\star - \wh) \right] \\
&= \left( \E_x\left[ f(x) x^T \right] - \E_x\left[ w_\star^T x x^T \right] \right) (w_\star - \wh) \\
&= \left( \E_x\left[ f(x) x^T \right] - \E_x\left[ f(x) x^T \right] \E_x\left[ x x^T \right]^{-1} \E_x\left[ x x^T \right] \right) (w_\star - \wh) \\
&= 0
\end{aligned}
$$

Since this result holds for arbitrary $$\wh$$, we can choose in particular $$\wh = \E_D[\wh_D]$$ and get our desired result

$$
\begin{aligned}
\E_x\left[ (\Bias[\fh(x)])^2 \right]
&= \E_x\left[ \left( f(x) - \E_D[ \fh_D(x) ] \right)^2 \right] \\
&= \E_x\left[ \left( f(x) - \E_D[\wh_D]^T x \right)^2 \right] \\
&= \E_x\left[ \left( f(x) - w_\star^T x \right)^2 \right] + \E_x\left[ \left( w_\star^T x - \E_D[\wh_D]^T x \right) \right].
\end{aligned}
$$

</details>

*Sources*

- "Decomposition of average squared bias." *StackExchange*. [link](https://stats.stackexchange.com/q/201779).
- Hastie, Trevor, et al. *The Elements of Statistical Learning*. 2nd ed., Springer, 2009. [link](https://web.stanford.edu/~hastie/Papers/ESLII.pdf).
    - Discussion leading up to equation (2.27), and Sections 7.1-7.3.

**Linear Regression for Arbitrary $$f$$**

Beyond deriving the values in the chart, we also prove that if the training data $$\Xbf$$ are fixed, then the average in-sample variance is $$\frac{1}{N}\sum_{i=1}^N \Var[\fh(x^{(i)})] = \frac{p}{N} \sigma^2$$.

<details markdown="block" class="proof"><summary>Details</summary>

The model prediction at a test point $$x$$ can be expressed as a linear combination of the input targets $$\ybf$$.

$$
\begin{aligned}
\fh(x)
&= \wh^T x \\
&= \ybf^T \Xbf (\Xbf^T \Xbf)^{-1} x \\
&= \ybf^T \hbf_\Xbf(x)
\end{aligned}
$$

First, we consider the case where the training inputs $$\Xbf$$ to be fixed while the training labels $$y$$ have variance $$\sigma^2$$. In other words, we treat $$\Xbf$$ as the marginal distribution $$P(X)$$. In this setting, although there is model bias if $$f$$ is not linear, the average estimation bias is 0 because $$w_\star = \wh_{\Xbf, f}$$, as shown previously.

$$
\begin{aligned}
\Bias[\fh(x) \mid \Xbf]
&= f(x) - \E_{\ybf | \Xbf}[ \fh(x) ] \\
&= f(x) - x^T \E_{\ybf | \Xbf}[ \wh ] \\
&= f(x) - x^T \wh_{\Xbf, f}
\\
\Var[\fh(x) \mid \Xbf]
&= x^T \Cov[\wh \mid \Xbf] x \\
&= \sigma^2 x^T (\Xbf^T \Xbf)^{-1} x \\
&= \sigma^2 \hbf_\Xbf(x)^T \hbf_\Xbf(x) \\
&= \sigma^2 \| \hbf_\Xbf(x) \|_2^2
\end{aligned}
$$

Taking the training data $$X$$ as an approximation of the true distribution $$P(X)$$ over inputs, we can compute the average *in-sample* variance

$$
\begin{aligned}
\frac{1}{N} \sum_{i=1}^N \Var[\fh(x^{(i)}) \mid \Xbf]
&= \frac{1}{N} \sum_{i=1}^N \sigma^2 x^{(i)T} (\Xbf^T \Xbf)^{-1} x^{(i)} \\
&= \frac{1}{N} \sigma^2 \tr(\Xbf (\Xbf^T \Xbf)^{-1} \Xbf^T) \\
&= \frac{1}{N} \sigma^2 \tr(\Xbf^T \Xbf (\Xbf^T \Xbf)^{-1}) \\
&= \frac{1}{N} \sigma^2 \tr(I_p) \\
&= \frac{p}{N} \sigma^2
\end{aligned}
$$

Thus, variance of a linear regression model increases linearly with the input dimension $$p$$ and decreases as $$1/N$$ in the training set size.

However, if the training inputs $$\Xbf$$ are not fixed but also sampled randomly, then the bias and variance are as follows. Notably, the estimation bias is not necessarily 0, because $$\E_\Xbf[ \wh_{\Xbf, f} ] \neq w_\star$$, as shown previously. In other words, linear regression has estimation bias under model misspecification.

$$
\begin{aligned}
\Bias[\fh(x)]
&= f(x) - \E_D[ \fh_D(x) ] \\
&= f(x) - x^T \E_D[ \wh_D ] \\
&= f(x) - x^T \E_\Xbf[ \wh_{\Xbf, f} ]
\\
\Var[\fh(x)]
&= \Var_D [ \fh_D(x) ]
 = x^T \Cov_D[\wh_D] x \\
&= x^T \left( \Cov_\Xbf[\wh_\Xbf] + \sigma^2 \E_\Xbf\left[(\Xbf^T \Xbf)^{-1}\right] \right) x \\
&= x^T \Cov_\Xbf[\wh_\Xbf] x + \sigma^2 \E_\Xbf[x^T \Zbf_\Xbf \Zbf_\Xbf^T x] \\
&= x^T \Cov_\Xbf[\wh_\Xbf] x + \sigma^2 \E_\Xbf\left[ \|\hbf_\Xbf(x)\|_2^2 \right]
\end{aligned}
$$

</details>

**Linear Regression for Linear $$f$$**

For linear $$f$$, in addition to proving the bias and variance results in the table above, we show that for large $$N$$ and assuming $$\E[X] = 0$$, the expected variance is $$\E_x[\Var[\fh(x)]] = \frac{p}{N} \sigma^2$$. Then, the expected MSE is

$$
\begin{aligned}
\E_x[MSE(x)]
&= \sigma^2 + \E_x \left[ \Bias_D[\fh_D(x)]^2 \right] + \E_x \left[ \Var_D [ \fh_D(x) ] \right] \\
&= \sigma^2 + 0 + \frac{p}{N} \sigma^2
= \sigma^2 \left(1 + \frac{p}{N}\right).
\end{aligned}
$$

<details markdown="block" class="proof"><summary>Details</summary>

Since the linear regression estimators are unbiased when $$f$$ is linear, the model also has no bias. Note that this means the model has zero model bias and zero estimation bias.

$$
\begin{aligned}
\Bias[\fh(x) \mid \Xbf] &= \Bias[\wh \mid \Xbf]^T x = 0 \\
\Bias[\fh(x)] &= \Bias[\wh]^T x = 0
\end{aligned}
$$

For the variance of the model, if the training inputs $$\Xbf$$ are fixed, the variance of a linear regression model for arbitrary $$f$$ is $$\sigma^2 \|\hbf_\Xbf(x)\|_2^2$$ which does not depend on $$f$$. Thus, it is the same regardless of whether $$f$$ is actually linear or not.

However, when the training inputs are sampled randomly, the variance does depend on $$f$$. When deriving the variance of the linear regression estimator for linear $$f$$, we saw that $$\Cov_\Xbf[\wh_\Xbf] = 0$$. Therefore, the variance of the model with randomly sampled inputs is

$$
\Var[\fh(x)]
= \sigma^2 \E_\Xbf\left[ \|\hbf_\Xbf(x)\|_2^2 \right]
= \sigma^2 x^T \E_\Xbf \left[ (\Xbf^T \Xbf)^{-1} \right] x.
$$

If $$N$$ is large and assuming $$\E[X] = 0$$, then $$\frac{1}{N} \Xbf^T \Xbf \to \Cov(X)$$ (see [Appendix](#appendix)), so $$\E_\Xbf \left[ (\Xbf^T \Xbf)^{-1} \right] \approx \frac{1}{N} \Cov(X)^{-1}$$.

$$
\begin{aligned}
\E_x[\Var[\fh(x)]]
&= \E_x \left[ \sigma^2 x^T \E_\Xbf \left[ (\Xbf^T \Xbf)^{-1} \right] x \right] \\
&\approx \frac{1}{N} \sigma^2 \E_x \left[ x^T \Cov(X)^{-1} x \right] \\
&= \frac{1}{N} \sigma^2 \E_x \left[ \tr( x^T \Cov(X)^{-1} x ) \right] \\
&= \frac{1}{N} \sigma^2 \E_x \left[ \tr( x x^T \Cov(X)^{-1} ) \right] \\
&= \frac{1}{N} \sigma^2 \tr\left( \E_x[x x^T] \Cov(X)^{-1} \right) \\
&= \frac{1}{N} \sigma^2 \tr\left( \Cov(X) \Cov(X)^{-1} \right) \\
&= \frac{1}{N} \sigma^2 \tr(I_p) \\
&= \frac{p}{N} \sigma^2
\end{aligned}
$$

</details>

*Sources*

- Weatherwax, John L., and David Epstein. *A Solution Manual and Notes for: The Elements of Statistical Learning*. 2019. [link](https://waxworksmath.com/Authors/G_M/Hastie/WriteUp/Weatherwax_Epstein_Hastie_Solution_Manual.pdf).
    - Chapter 2, variance of linear regression model when actual data relationship is linear.

**Ridge Regression**

The bias and variance expressions for ridge regression come as a straightforward application of the equations (copied again below) that use the existing results for the bias and variance of the ridge regression estimators.

$$
\begin{aligned}
\Bias[\fh(x)] &= \Bias[\wh]^T x \\
\Var[\fh(x)] &= x^T \Cov_D[ \wh_D ]\ x
\end{aligned}
$$

These equations also make it clear why we compare the definiteness of the covariance matrices between different estimators. Since we know that $$\Cov[\whR] \prec \Cov[\wh]$$, then by definition

$$
\begin{aligned}
& \forall x.\ x^T \left( \Cov[\wh] - \Cov[\whR] \right) x > 0 \\
&\iff \forall x.\ x^T \Cov[\wh] x - x^T \Cov[\whR] x > 0 \\
&\iff \forall x.\ \Var[\fh(x)] > \Var[\fhR(x)].
\end{aligned}
$$


# Further areas of investigation

When writing this post, I was unable to determine whether the variance of $$\whR$$ is lower than the variance of $$\wh$$ when the training inputs $$\Xbf$$ are sampled randomly. I was only able to find a proof assuming $$\Xbf$$ are fixed. If you happen to have any ideas, please let me know through a GitHub issue!

# Appendix

**Linearity of Expectation for Matrices**

Suppose $$A \in \R^{n \times k}$$ is a random matrix and $$X \in \R^{k \times k}$$ is a random matrix, where $$A$$ and $$X$$ are independent. Then,

$$
\begin{aligned}
\E_{A, X}[A X A^T]
&= \sum_A \sum_X P(A, X) A X A^T \\
&= \sum_A \sum_X P(A) P(X) A X A^T \\
&= \sum_A P(A) A \left( \sum_X P(X) X \right) A^T \\
&= \sum_A P(A) A \E_X[X] A^T \\
&= \E_A[ A\ \E_X[X]\ A^T ]
\end{aligned}
$$

**Covariance**

Let $$X$$ be a random vector, and let $$\Xbf$$ be a matrix containing $$N$$ i.i.d. samples of $$X$$:

$$
\Xbf = \begin{bmatrix}
- & x^{(1)} & - \\
  & \vdots  &   \\
- & x^{(N)} & - \\
\end{bmatrix}
$$

Then, the covariance of $$X$$ is defined as

$$ \Cov(X) = \E[X X^T] - \E[X] \E[X]^T. $$

If $$\E[X] = 0$$, then the covariance can be approximated by

$$ \Cov(X) \approx \frac{1}{N} \sum_{i=1}^N x^{(i)} x^{(i)T} = \frac{1}{N} \Xbf^T \Xbf $$

for large $$N$$.