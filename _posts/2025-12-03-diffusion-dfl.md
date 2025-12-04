---
title: >
  Diffusion DFL: Decision-focused Diffusion Models for Stochastic Optimization
layout: post
use_math: true
use_toc: true
last_updated: 2025-12-03
tags: [ML]
pin: true
excerpt: In this blog post, I explain the core mathematical principles behind Diffusion DFL, a novel decision-focused learning method that leverages diffusion models to capture complex, multimodal distributions of uncertain parameters for improved decision-making in stochastic optimization problems.
---

This post is based on the following work with my excellent collaborators [Zihao Zhang](https://www.zihaozhao.site/), [Lingkai Kong](https://lingkai-kong.com/), and [Kai Wang](https://guaguakai.com/).

> Z. Zhao, C. Yeh, L. Kong, and K. Wang, “Diffusion-DFL: Decision-focused Diffusion Models for Stochastic Optimization.” arXiv, Oct. 13, 2025. doi: 10.48550/arXiv.2510.11590. Available: [http://arxiv.org/abs/2510.11590](http://arxiv.org/abs/2510.11590).

Decision-focused learning (DFL) is a framework for learning prediction models that are optimized end-to-end for downstream decision-making tasks. Traditionally, DFL methods have focused on deterministic optimization problems, where the decision is made based on a point estimate of some uncertain parameters. However, in many real-world settings, the uncertain parameter may have a multimodal distribution which cannot be adequately captured by a point estimate. In such cases, a point estimate may lead to poor decision quality.

To address this limitation, we propose Diffusion DFL, a novel DFL framework that leverages diffusion models to capture complex, multimodal distributions of uncertain parameters. By integrating diffusion models into the DFL framework, Diffusion DFL enables more accurate modeling of uncertainty, leading to improved decision quality in stochastic optimization problems.

A fundamental challenge in using diffusion models in decision-focused learning, though, is that DFL requires backpropagation through the sampling procedure of the generative model. A naive approach using the reparameterization trick would require backpropagating through the entire diffusion sampling process, which can be computationally expensive and memory-intensive. To overcome this challenge, we propose a novel approximate but much more memory-efficient gradient estimator based on the statistical score function.

This post assumes some familiarity with these concepts:
- convex optimization
    - S. Boyd and L. Vandenberghe, _Convex Optimization_, 1st ed. Cambridge University Press, 2004. [(link)](https://stanford.edu/~boyd/cvxbook/)
- decision-focused learning and the implicit function theorem
    - P. Donti, B. Amos, and J. Z. Kolter, "Task-based End-to-end Model Learning in Stochastic Optimization," in _Advances in Neural Information Processing Systems_, 2017. [(link)](https://proceedings.neurips.cc/paper_files/paper/2017/hash/3fc2c60b5782f641f76bcefc39fb2392-Abstract.html)
    - S. Barratt, "On the Differentiability of the Solution to Convex Optimization Problems," arXiv.org. [(link)](http://arxiv.org/abs/1804.05098)
- conditional diffusion models
    - J. Ho, A. Jain, and P. Abbeel, "Denoising Diffusion Probabilistic Models," in _Advances in Neural Information Processing Systems_, 2020. [(link)](https://proceedings.neurips.cc/paper/2020/hash/4c5bcfec8584af0d967f1ab10179ca4b-Abstract.html)
    - Y. Tashiro, J. Song, Y. Song, and S. Ermon, "CSDI: Conditional Score-based Diffusion Models for Probabilistic Time Series Imputation," in _Advances in Neural Information Processing Systems_, 2021. [(link)](https://proceedings.neurips.cc/paper/2021/hash/cfe8504bda37b575c70ee1a8276f3486-Abstract.html)
- Monte Carlo gradient estimation (e.g., reparameterization trick and score function estimator)
    - S. Mohamed, M. Rosca, M. Figurnov, and A. Mnih, "Monte Carlo Gradient Estimation in Machine Learning," _Journal of Machine Learning Research_, vol. 21, no. 132, pp. 1–62, 2020. [(link)](http://jmlr.org/papers/v21/19-346.html)


**Notation:** Let $$\pderiv{f}{x}$$ denote the Jacobian matrix where $$\big(\pderiv{f}{x}\big)_{i,j} := \pderiv{f_i}{x_j}$$ and $$\nabla_x f := \big(\pderiv{f}{x}\big)^\top$$ denote the gradient. For a vector $$v$$, $$\diag(v)$$ denotes a diagonal matrix with $$v$$ on its diagonal.

## Background

Suppose we would like to learn a "policy" $$z_\theta: \Xcal \to \Zcal$$ to minimize the expected cost

$$ \E_{\Pcal(x,y)} \left[ f(y, z_\theta(x)) \right] $$

where $$f: \Ycal \times \Zcal \to \R$$ is a cost function, and $$\Pcal$$ is a data distribution over $$\Xcal \times \Ycal$$. We require $$z_\theta(x)$$ to satisfy the constraint $$h(x, z_\theta(x)) \leq 0$$ for some constraint function $$h: \Xcal \times \Zcal \to \R^{d_h}$$.

Let $$\theta \in \Theta \subseteq \R^{d_\theta}$$ denote the parameters of our policy that we seek to learn. Let $$\Xcal \subseteq \R^{d_x}$$, $$\Ycal \subseteq \R^{d_y}$$, and $$\Zcal \subseteq \R^{d_z}$$.

For simplicity of notation, we will drop the $$x$$-dependence for the rest of this note (i.e., suppose there is only a single $$x$$), and just consider a fixed $$z_\theta \in \Zcal$$ that aims to minimize the expected decision cost

$$ F(\theta) := \E_{\Pcal(y)} \left[ f(y, z_\theta) \right]. $$

Suppose that we are able to learn a distribution $$p_\theta(y)$$ that perfectly models the data distribution $$\Pcal$$, i.e., $$p_\theta(y) = \Pcal(y)$$. Then the optimal policy is the solution to the stochastic optimization problem

$$
    z_\theta
    = \argmin_z \E_{p_\theta(\hat{y})} \left[ f(\hat{y}, z) \right] \quad\text{s.t.}\quad h(z) \leq 0.
$$

Thus, a natural approach is to first train $$p_\theta$$ to model the data distribution $$\Pcal$$ as accurately as possible, then set $$z_\theta$$ as above. This is known as the two-stage "prediction-focused learning" (PFL) approach.

Alternatively, we may wish to optimize $$\theta$$ directly for the policy performance, resulting in the so-called "decision-focused learning" (DFL) approach. That is, we seek to find parameters that minimize our decision cost, i.e., $$\argmin_\theta F(\theta)$$.

Importantly, the policy $$z_\theta$$ defined as the solution to the stochastic optimization problem above is _consistent_: if we learn $$\theta$$ perfectly so that $$p_\theta(y) = \Pcal(y)$$, then we recover the optimal policy.

In this note, we will be primarily interested in the setting where $$p_\theta$$ is a diffusion model trained to approximate the data distribution $$\Pcal$$. However, many of the mathematical principles presented here apply to any generative model such as normalizing flows or variational autoencoders.

## Alternative but inconsistent parameterization: Deterministic Optimization

Within the DFL framework, we need not be restricted to the policy parameterization $$z_\theta$$ above. Instead, we can consider two policy parameterizations:

1. $$z_\theta$$ remains the solution to the stochastic optimization problem; or
2. $$z_\theta^{\text{det}}(\hat{y})$$ is the solution to a deterministic optimization problem given a sample $$\hat{y} \sim p_\theta$$:

    $$
        z_\theta^{\text{det}}(\hat{y})
        := \argmin_z f(\hat{y}, z) \quad\text{s.t.}\quad h(z) \leq 0.
    $$

    In practice, we would draw a single sample $$\hat{y} \sim p_\theta$$, take the decision $$z_\theta^{\text{det}}(\hat{y})$$, then incur the true cost $$f(y, z_\theta^{\text{det}}(\hat{y}))$$ where $$y \sim \Pcal$$ is the true outcome.

The first case is what we propose in Diffusion DFL. The second case is proposed by Silvestri et al. (2023).

> M. Silvestri et al., “Score Function Gradient Estimation to Widen the Applicability of Decision-Focused Learning,” in _ICML 2023 Workshop on Differentiable Almost Everything: Differentiable Relaxations, Algorithms, Operators, and Simulators_, Sept. 2023. [Online]. Available: [https://openreview.net/forum?id=ty046JUllZ](https://openreview.net/forum?id=ty046JUllZ)

In either case, we want to optimize $$\theta$$ to minimize the expected decision cost $$F(\theta)$$.

Let's briefly compare the two policy parameterizations within DFL. Suppose that we learn $$\theta$$ perfectly, so that $$p_\theta(y) = \Pcal(y)$$. In the first case, we recover the optimal policy (as in the two-stage PFL approach). However, in the second case, we have that for every $$\hat{y}$$,

$$
    \E_{\Pcal(y)}[ f(y, z_\theta^{\text{det}}(\hat{y})) ]
    \geq \min_z \E_{\Pcal(y)}[ f(y,z) ]
    \label{1}\tag{1}.
$$

Since this holds for every $$\hat{y}$$, we can take the expectation over $$\hat{y} \sim p_\theta$$ to obtain

$$\begin{aligned}
    \E_{p_\theta(\hat{y})} \left[ \E_{\Pcal(y)} \left[ f(y, z_\theta^{\text{det}}(\hat{y})) \right] \right]
    &= \E_{y \sim \Pcal,\, \hat{y} \sim p_\theta}\left[ f(y, z_\theta^{\text{det}}(\hat{y})) \right] \\
    &\geq \min_z \E_{\Pcal(y)} [ f(y,z) ] \\
    &= \E_{\Pcal(y)} \left[ f(y, z_\theta) \right].
\end{aligned}$$

As long as there exists a nonnegligible subset of $$\hat{y}$$ values where the inequality in $$\eqref{1}$$ is strict, then $$z_\theta^\text{det}$$ incurs a strictly higher expected cost than the optimal policy $$z_\theta$$, even with perfect generative modeling. Thus, the deterministic policy parameterization is not _consistent_.

A special case of the $$z_\theta^\text{det}$$ policy arises when $$p_\theta$$ is a delta distribution centered at a point estimate $$\hat{y}_\theta$$. In this case, the policy reduces to $$z_\theta^{\text{det}} = \argmin_z f(\hat{y}_\theta, z)$$, which is the standard "predict-then-optimize" approach studied in prior DFL works. The analysis above shows that this standard approach can also be inconsistent.


## Computing gradients through stochastic optimization problems

Recall that we consider a policy defined as

$$
z_\theta \ = \ \argmin_z \
\E_{p_\theta(y)} \left[ f(y,z) \right]
\quad\text{s.t.}\quad h(z) \leq 0,
$$

and we wish to optimize $$\theta$$ to minimize the expected decision cost

$$ F(\theta) = \E_{\Pcal(y)} \left[ f(y, z_\theta) \right]. $$

An intuitive approach is to perform gradient descent on $$\theta$$, requiring the computation of the gradient $$\nabla_\theta F(\theta)$$. By the chain rule, we have

$$\begin{aligned}
    \deriv{F(\theta)}{\theta}
    &= \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \cdot \deriv{z_\theta}{\theta}(\theta) \right] \\
    &= \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \right] \cdot \deriv{z_\theta}{\theta}(\theta).
\end{aligned}$$

Computing the term $$\deriv{z_\theta}{\theta}(\theta)$$ may appear challenging, since $$z_\theta$$ is defined as the solution to a stochastic optimization problem. To overcome this problem, we can invoke the implicit function theorem on the KKT conditions of the stochastic optimization problem to compute $$\deriv{z_\theta}{\theta}(\theta)$$.

The Lagrangian of the stochastic optimization problem is

$$
    L(z, \lambda, \theta)
    = \E_{p_\theta(y)} \left[ f(y,z) \right] + \lambda^\top h(z),
$$

where $$\lambda$$ is the vector of Lagrange multipliers associated with the inequality constraints $$h(z) \leq 0$$. Let $$(z_\theta, \lambda_\theta)$$ be a primal-dual optimal solution pair. The KKT equality conditions are

$$\begin{aligned}
\nabla_z L(z_\theta, \lambda_\theta, \theta)
    = \E_{p_\theta(y)} \left[ \nabla_z f(y, z_\theta) \right] + \nabla_z h(z_\theta) \cdot \lambda_\theta
    &= 0 \\
\diag(\lambda_\theta)\, h(z_\theta) &= 0.
\end{aligned}$$

Define

$$
    r(z,\lambda,\theta) = \begin{bmatrix}
        \nabla_z L(z, \lambda, \theta) \\
        \diag(\lambda)\,h(z)
    \end{bmatrix}.
$$

Then we are searching for a solution mapping $$\theta \mapsto (z_\theta, \lambda_\theta)$$ such that $$r(z_\theta, \lambda_\theta, \theta) = 0$$. Taking the total derivative with respect to $$\theta$$, we have

$$
    \deriv{r}{\theta}(z_\theta, \lambda_\theta, \theta)
    = \pderiv{r}{(z,\lambda)}(z_\theta, \lambda_\theta, \theta) \cdot \deriv{(z_\theta, \lambda_\theta)}{\theta} (\theta)
    + \pderiv{r}{\theta}(z_\theta, \lambda_\theta, \theta)
    = 0.
$$

Rearranging yields the implicit derivative,

$$
    \deriv{(z_\theta, \lambda_\theta)}{\theta} (\theta)
    = - \left( \pderiv{r}{(z,\lambda)}(z_\theta, \lambda_\theta, \theta) \right)^{-1} \pderiv{r}{\theta}(z_\theta, \lambda_\theta, \theta).
$$

Let us define $$J$$ as the partial Jacobian of $$r$$ with respect to $$(z,\lambda)$$, which simplifies as

$$\begin{aligned}
J
&:= \pderiv{r}{(z,\lambda)}(z_\theta, \lambda_\theta, \theta) \\
&= \begin{bmatrix}
    \pderiv{}{z} \nabla_z L(z_\theta, \lambda_\theta, \theta)
        & \pderiv{}{\lambda} \nabla_z L(z_\theta, \lambda_\theta, \theta) \\
    \pderiv{}{z} \left[ \diag(\lambda_\theta)\, h(z_\theta) \right]
        & \pderiv{}{\lambda} \left[ \diag(\lambda_\theta)\, h(z_\theta) \right]
\end{bmatrix}
= \begin{bmatrix}
    \nabla_{zz}^2 L(z_\theta, \lambda_\theta, \theta)
        & \nabla_z h(z_\theta) \\
    \diag(\lambda_\theta)\, \pderiv{h}{z}(z_\theta)
        & \diag(h(z_\theta))
\end{bmatrix} \\
&= \begin{bmatrix}
    \E_{p_\theta(y)}[\nabla_{zz}^2 f(y, z_\theta)] + \nabla^2_{zz} (\lambda_\theta^\top h(z_\theta))
        & \nabla_z h(z_\theta) \\
    \diag(\lambda_\theta)\, \pderiv{h}{z}(z_\theta)
        & \diag(h(z_\theta))
\end{bmatrix} \\
&= \begin{bmatrix}
    H & G \\
    \diag(\lambda_\theta) G^\top & \diag(h(z_\theta))
\end{bmatrix}
\end{aligned}$$

where $$H := \E_{p_\theta(y)}[\nabla_{zz}^2 f(y, z_\theta)] + \nabla^2_{zz} (\lambda_\theta^\top h(z_\theta))$$ and $$G := \nabla_z h(z_\theta)$$.

The partial Jacobian of $$r$$ with respect to $$\theta$$ is

$$
\pderiv{r}{\theta}(z_\theta, \lambda_\theta, \theta)
= \begin{bmatrix}
    \pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right] \\
    \zero_{d_h \times d_\theta}
\end{bmatrix}
$$

where the partial derivative on the right-hand side only acts on the distribution $$p_\theta$$. Thus, we have

$$
\begin{bmatrix}
    \deriv{z_\theta}{\theta}(\theta) \\
    \deriv{\lambda_\theta}{\theta}(\theta)
\end{bmatrix}
= -J^{-1}
\begin{bmatrix}
    \pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right] \\
    \zero_{d_h \times d_\theta}
\end{bmatrix}
$$

Finally, we can extract just the top block to recover the desired gradient of $$F$$:

$$\begin{aligned}
    \deriv{F}{\theta}(\theta)
    &= \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \right] \cdot \deriv{z_\theta}{\theta}(\theta) \\
    &= \begin{bmatrix}
        \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \right] & \zero_{1 \times d_h}
    \end{bmatrix} \cdot
    \begin{bmatrix}
        \deriv{z_\theta}{\theta}(\theta) \\
        \deriv{\lambda_\theta}{\theta}(\theta)
    \end{bmatrix} \\
    &= - \begin{bmatrix}
        \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \right] & \zero_{1 \times d_h}
    \end{bmatrix} \cdot
    J^{-1}
    \begin{bmatrix}
        \pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right] \\
        \zero_{d_h \times d_\theta}
    \end{bmatrix}
\end{aligned}$$

The equation above is the general expression for the gradient of the expected decision cost $$F(\theta)$$. To complete the expression, we need to compute the term

$$
    \pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right].
$$

In practice, the expectation over $$\hat{y} \sim p_\theta$$ is approximated by sampling from a generative model, such as a diffusion model. Thus, this term requires differentiating through the sampling procedure of the generative model, which can be challenging. The next two sections will present two approaches to compute this term. The first approach is based on the reparameterization trick, while the second approach is based on the score function estimator.

As an aside, we will briefly mention that under some additional assumptions, the matrix inverse in the expression above can be computed efficiently using the [matrix inversion lemma](https://chrisyeh96.github.io/2021/05/19/schur-complement.html). First, assume that $$J$$ is invertible. Then, there are two cases of interest.

1. If $$H$$ is invertible, i.e., the Lagrangian is strongly convex in $$z$$ for fixed $$\lambda$$ and $$\theta$$, then
   
    $$ J^{-1} = \begin{bmatrix}
        H^{-1} + H^{-1} G (J_H)^{-1} \diag(\lambda_\theta) G^\top H^{-1}
            & \dotsb \\
        \dotsb & \dotsb
    \end{bmatrix} $$

    where $$J_H := \diag(h(z_\theta)) - \diag(\lambda_\theta) G^\top H^{-1} G$$ is the Schur complement of $$J$$ with respect to its upper-left block $$H$$. The ellipses indicate the rest of the matrix, whose values are irrelevant. Then,

    $$
        \deriv{F}{\theta}(\theta)
        = - \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \right] \cdot
        \left( H^{-1} + H^{-1} G (J_H)^{-1} \diag(\lambda_\theta) G^\top H^{-1} \right)
        \cdot \pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right].
    $$

2. If $$\diag(h(z_\theta))$$ is invertible, i.e., all constraints are inactive at optimality, then

    $$
        J^{-1} = \begin{bmatrix}
            (H - G \diag(h(z_\theta))^{-1} \diag(\lambda_\theta) G^\top)^{-1}
                & \dotsb \\
            \dotsb & \dotsb
        \end{bmatrix}.
    $$

    Then,

    $$
        \deriv{F}{\theta}(\theta)
        = - \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \right] \cdot
        \left( H - G \diag(h(z_\theta))^{-1} \diag(\lambda_\theta) G^\top \right)^{-1}
        \cdot \pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right].
    $$


## Diffusion models

We consider the DDPM (denoising diffusion probabilistic models) formulation of diffusion models proposed by Ho et al. (2020). For our purposes, it suffices to treat a diffusion model as a noise prediction network $$\hat\epsilon_\theta: \R^{d_y} \times \{1, \dotsc, T\} \to \R^{d_y}$$ that is trained to predict the noise added to data samples at different noise levels.

Associated with the diffusion model is a variance schedule $$\beta_1, \dotsc, \beta_T \in (0,1)$$ that determines the amount of noise added at each diffusion step. For convenience, it is common to define the constants $$\alpha_t := 1 - \beta_t$$, $$\bar\alpha_t := \prod_{i=1}^t \alpha_i$$, and $$\sigma_t^2 = \beta_t$$. See Ho et al. (2020) for more details.


## Reparameterization trick

The challenge of differentiating through the sampling procedure of generative models has been extensively studied in the literature. Perhaps the most well-known approach is the reparameterization trick used in training variational autoencoders, which expresses the sampling procedure as a deterministic function of a noise variable.

Formally, suppose that a sample $$y \sim p_\theta$$ can be expressed as a transformation $$y = R(\epsilon; \theta)$$ of a noise variable $$\epsilon \sim p(\epsilon)$$ that does not depend on $$\theta$$. Then, the reparameterization trick (a.k.a. pathwise derivative) states that

$$\begin{aligned}
    \pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right]
    &= \pderiv{}{\theta} \E_{p(\epsilon)} \left[ \nabla_z f(R(\epsilon; \theta), z_\theta) \right] \\
    &= \E_{p(\epsilon)} \left[
        \pderiv{}{y}(\nabla_z f(R(\epsilon; \theta), z_\theta)) \cdot \pderiv{R}{\theta}(\epsilon; \theta)
    \right]
    \\
    &= \E_{p(\epsilon)} \left[
        \nabla_{zy}^2 f(R(\epsilon; \theta), z_\theta) \cdot \pderiv{R}{\theta}(\epsilon; \theta)
    \right].
\end{aligned}$$

Then, the overall gradient of the expected decision cost is

$$\begin{aligned}
    \deriv{F}{\theta}(\theta)
    &= \underbrace{- \begin{bmatrix}
        \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \right] & \zero_{1 \times d_h}
    \end{bmatrix} \cdot
    J^{-1}}_{=w_\theta} \cdot
    \begin{bmatrix}
        \E_{p(\epsilon)}\left[ \nabla_{zy}^2 f(R(\epsilon; \theta), z_\theta) \cdot \pderiv{R}{\theta}(\epsilon; \theta) \right]\\
        \zero_{d_h \times d_\theta}
    \end{bmatrix}
    \\
    &= w_\theta \cdot \begin{bmatrix}
        \E_{p(\epsilon)}\left[ \nabla_{zy}^2 f(R(\epsilon; \theta), z_\theta) \cdot \pderiv{R}{\theta}(\epsilon; \theta) \right]\\
        \zero_{d_h \times d_\theta}
    \end{bmatrix}.
\end{aligned}$$

Observe that if we set $$w := w_\theta$$ and $$z := z_\theta$$ as fixed values (independent of $$\theta$$), then the gradient above can be interpreted as the gradient of the surrogate objective

$$
    F_\text{surrogate}(\theta)
    := w \cdot \begin{bmatrix}\E_{p(\epsilon)}[\nabla_z f(R(\epsilon; \theta), z)] \\ \zero_{d_h} \end{bmatrix}
$$

since

$$
\deriv{F_\text{surrogate}}{\theta}(\theta)
= w \cdot \begin{bmatrix} \E_{p(\epsilon)} \left[
    \nabla_{zy}^2 f(R(\epsilon; \theta), z) \cdot \pderiv{R}{\theta}(\epsilon; \theta)
\right] \\ \zero_{d_h \times d_\theta} \end{bmatrix}.
$$

Let's see how this applies to a diffusion model with $$T$$ diffusion steps. The sampling process for a diffusion model starts with white noise $$y_T \sim \Gaussian(0, I)$$. Then, for each diffusion step $$t = T, T-1, \dotsc, 1$$, we draw an independent noise sample $$\epsilon_{t-1} \sim \Gaussian(0, I)$$ and compute

$$
    y_{t-1} = \frac{1}{\sqrt{\alpha_t}} \left( y_t - \frac{1 - \alpha_t}{\sqrt{1 - \bar{\alpha}_t}} \hat\epsilon_\theta(y_t, t) \right) + \sigma_t \epsilon_{t-1}.
$$

By unrolling the entire diffusion sampling process, we can express the final sample $$y_0$$ as a deterministic function of the noise variables $$\epsilon_{0:T}$$ where $$\epsilon_T := y_T$$. That is, $$y_0 = R(\epsilon_{0:T}; \theta)$$ for some function $$R$$ defined by the diffusion sampling process.

**Diffusion DFL reparameterization training algorithm**

Assume that we have closed-form expressions for $$\nabla_{zz}^2 f(y,z)$$, $$\nabla_{zz}^2 (\lambda^\top h(x,z))$$, $$\nabla_z h(x,z)$$, and $$\nabla_z f(y,z)$$, so that we can compute $$H$$, $$G$$, and $$J$$ as needed.

For each minibatch of data examples $$(x_1, y_1), \dotsc, (x_N, y_N) \iid \Pcal$$:

1. For each $$n=1,\dotsc,N$$:
    1. For $$m = 1, \dotsc, M$$:
        1. Draw independent noise samples $$\epsilon_{0:T}^{(m)} \iid \Gaussian(0, I)$$.
        2. Convert the noise sample into a predictive sample $$\hat{y}_m = R(\epsilon_{0:T}^{(m)}; \theta)$$.
    2. With gradient tracking disabled (`torch.no_grad()`):
        1. Solve the stochastic optimization problem

            $$
            z_\theta \approx \argmin_z \frac{1}{M} \sum_{m=1}^M f(\hat{y}_m, z) \quad\text{s.t.}\quad h(x_n, z) \leq 0
            $$

            with the corresponding optimal Lagrange multipliers $$\lambda_\theta$$.
        2. Compute the matrices

            $$\begin{aligned}
            H &= \frac{1}{M} \sum_{m=1}^M \nabla_{zz}^2 f(\hat{y}_m, z_\theta) + \nabla^2_{zz} \left( \lambda_\theta^\top h(x_n, z_\theta) \right)
            \\
            G &= \nabla_z h(x_n, z_\theta)
            \\
            J &= \begin{bmatrix}
                H & G \\
                \diag(\lambda_\theta)\, G^\top & \diag(h(x_n, z_\theta))
            \end{bmatrix}
            \end{aligned}$$
        3. Compute the weight

            $$
            w_n := -\begin{bmatrix}
                \pderiv{f}{z}(y_n, z_\theta) & \zero_{1 \times d_h}
            \end{bmatrix} \cdot J^{-1}.
            $$
    3. With gradient tracking enabled (`torch.enable_grad()`):
        1. Compute the surrogate objective $$F_n(\theta) = w_n \cdot \begin{bmatrix} \frac{1}{M} \sum_{m=1}^M \nabla_z f(\hat{y}_m, z_\theta) \\ \zero_{d_h} \end{bmatrix}$$.
2. Compute the surrogate expected decision cost for the minibatch: $$F(\theta) = \frac{1}{N} \sum_{n=1}^N F_n(\theta)$$.
3. Backpropagate gradients ($$F$$.backward()) and take a gradient step.

**Memory usage challenges:** The main issue with the reparameterization trick approach is that it requires significant memory usage, typically on the GPU, yet GPU memory is often limited. Specifically, the term $$\pderiv{R}{\theta}(\epsilon; \theta)$$ requires computing the Jacobian of the entire diffusion sampling process with respect to $$\theta$$, which involves storing all intermediate diffusion steps $$y_T, y_{T-1}, \dotsc, y_0$$. The memory usage for backpropagating through one sample $$\hat{y}_m$$ is therefore analogous to backpropagating through one denoising step with a batch size of $$T$$. When drawing $$M$$ samples per data example and using a minibatch size of $$N$$, the "effective batch size" is $$O(N M T)$$, where an "effective batch size" of 1 corresponds to the amount of memory required to backpropagate through a single denoising step for a single input. For diffusion models with many diffusion steps (e.g., $$T=1000$$, as in the original DDPM paper), this can lead to prohibitively high memory usage. In the next section, we present an alternative approach based on the score function estimator that avoids this issue.


## Score function estimator

In this section, we present an approach based on the score function estimator (also known as REINFORCE or the likelihood ratio method) to compute the derivative through the sampling procedure of the generative model,

$$
    \pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right].
$$

By the log-derivative trick, we have

$$
\begin{aligned}
    \pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right]
    &= \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \cdot \pderiv{}{\theta} \ln p_\theta(\hat{y}) \right] \\
    &= \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \cdot \left(\nabla_\theta \ln p_\theta(\hat{y})\right)^\top \right].
\end{aligned}$$

Thus, as long as we can compute the _score function_ $$\nabla_\theta \ln p_\theta(\hat{y})$$, we can compute the desired gradient. For example, if $$p_\theta$$ is a Gaussian distribution $$\Gaussian(\mu_\theta, \Sigma_\theta)$$, then the score function has a closed-form expression. Similarly, if $$p_\theta$$ is a normalizing flow model, then the score function can be computed exactly and efficiently using the change-of-variables formula.

For diffusion models, though, this score function generally cannot be computed efficiently. Instead we shall approximate it using the gradient of the evidence lower bound (ELBO) objective used to train diffusion models.

A diffusion model has latent variables $$y_{1:T} = (y_1, \dotsc, y_T)$$ corresponding to noisy versions of the data $$y_0 := y$$, and the variational distribution of the diffusion model (i.e., the forward process) is denoted $$q(y_{1:T} \mid y_0)$$. The ELBO is defined as

$$\begin{aligned}
    \text{ELBO}(\theta; y_0)
    &:= \E_{q(y_{1:T} \mid y_0)} \left[
        \ln p_\theta(y_{0:T})
        - \ln q(y_{1:T} \mid y_0)
    \right] \\
    &= \ln p_\theta(y_0) - \KL(q(y_{1:T} \mid y_0) \,\|\, p_\theta(y_{1:T} \mid y_0)).
\end{aligned}$$

Define $$s_\theta(y_{1:T}; y_0) := \nabla_\theta \ln p_\theta(y_{0:T})$$ as the score function for the joint distribution of observations and latent variables. Now, we are ready to present an upper-bound on the difference between the score function and the gradient of the ELBO.

If there exists an upper bound $$B(\theta, y_0)$$ on the norm of the score function,

$$
    \sup_{y_{1:T}} \| s_\theta(y_{1:T}; y_0) \| \leq B(\theta, y_0),
$$

then

$$
    \norm{
        \nabla_\theta \ln p_\theta(y_0) - \nabla_\theta \text{ELBO}(\theta; y_0)
    }
    \leq 2 B(\theta, y_0) \cdot \sqrt{
        \KL(q(y_{1:T} \mid y_0) \,\|\, p_\theta(y_{1:T} \mid y_0))
    }.
$$

This result is a straightforward application of the triangle inequality and Pinsker's inequality. We present a more general version below.

**Proposition:** Let $$p_\theta(w,y)$$ be a joint distribution parameterized by $$\theta$$ over latent variables $$w$$ and observations $$y$$. Define the score function $$s_\theta(w; y) := \nabla_\theta \ln p_\theta(w,y)$$ for the joint distribution. Let $$q(w)$$ be any distribution over the latent variables. If there exists $$B(\theta, y)$$ such that $$\sup_w \| s_\theta(w; y) \| \leq B(\theta, y)$$, then

$$
    \norm{ \nabla_\theta \ln p_\theta(y) - \nabla_\theta \text{ELBO}(\theta; y) }
    \leq 2 B(\theta, y) \cdot \sqrt{ \KL(q(w) \,\|\, p_\theta(w \mid y)) }.
$$

<details markdown="block" class="proof"><summary>Proof</summary>

First, we derive the so-called score function identity for latent variable models:

$$\begin{aligned}
    \nabla_\theta \ln p_\theta(y)
    &= \frac{1}{p_\theta(y)} \cdot \nabla_\theta p_\theta(y) \\
    &= \frac{1}{p_\theta(y)} \cdot \int \nabla_\theta p_\theta(w,y) \ \diff w \\
    &= \frac{1}{p_\theta(y)} \cdot \int p_\theta(w,y) \cdot \nabla_\theta \ln p_\theta(w,y) \ \diff w \\
    &= \int \frac{p_\theta(w,y)}{p_\theta(y)} \cdot s_\theta(w; y) \ \diff w \\
    &= \E_{p_\theta(w \mid y)} \left[ s_\theta(w; y) \right].
\end{aligned}$$

The gradient of the ELBO can be equivalently written as

$$\begin{aligned}
    \nabla_\theta \text{ELBO}(\theta; y)
    &= \nabla_\theta \E_{q(w)} \left[ \ln p_\theta(w,y) - \ln q(w) \right] \\
    &= \E_{q(w)} \left[ \nabla_\theta \ln p_\theta(w,y) \right] \\
    &= \E_{q(w)} \left[ s_\theta(w; y) \right].
\end{aligned}$$

Then,

$$\begin{aligned}
    &\norm{
        \nabla_\theta \text{ELBO}(\theta; y) - \nabla_\theta \ln p_\theta(y)
    } \\
    &= \norm{
        \E_{q(w)} \left[ s_\theta(w; y) \right]
        - \E_{p_\theta(w \mid y)} \left[ s_\theta(w; y) \right]
    } \\
    &= \norm{
        \int s_\theta(w; y) \left( q(w) - p_\theta(w \mid y) \right) \ \diff w
    } \\
    &\leq \int \norm{ s_\theta(w; y) } \cdot \abs{q(w) - p_\theta(w \mid y)} \ \diff w \\
    &\leq B(\theta, y) \cdot \int | q(w) - p_\theta(w \mid y) | \ \diff w \\
    &= B(\theta, y) \cdot 2\operatorname{TV}(q(w), p_\theta(w \cdot \mid y)) \\
    &\leq \sqrt{2} \cdot B(\theta, y) \cdot \sqrt{
        \KL(q(w) \,\|\, p_\theta(w \mid y))
    }.
\end{aligned}$$

The first inequality uses the triangle inequality, the second inequality uses the assumed bound on the score function norm, and the third inequality uses Pinsker's inequality,

$$
    \operatorname{TV}(p, q)
    \leq \sqrt{\frac{1}{2} \KL(p \,\|\, q)}.
$$

The last equality uses the definition of total variation distance,

$$
    \operatorname{TV}(p, q) = \frac{1}{2} \int | p(w) - q(w) | \ \diff w.
$$

$$\blacksquare$$
</details>

For diffusion models, the ELBO is equal to

$$
    \text{ELBO}(\theta; y_0) = \sum_{t=1}^T \frac{1}{2 \sigma_t^2} \frac{(1-\alpha_t)^2}{(1 - \bar\alpha_t) \alpha_t} \E_{\epsilon_t \sim \Gaussian(0,I)} \left[ \norm{\hat\epsilon_\theta(y_t,t) - \epsilon_t}_2^2 \right]
    + \text{const},
$$

where $$y_t = \sqrt{\bar\alpha_t} y_0 + \sqrt{1 - \bar\alpha_t} \epsilon_t$$ is a sample with added noise.

Typically, though, the ELBO objective for diffusion models is implemented without the weighting factors, resulting in the simplified objective

$$
    \text{ELBO}(\theta; y_0)
    \approx \E_{t \in [T],\,\epsilon_t \sim \Gaussian(0,I)} \left[ \norm{\hat\epsilon_\theta(y_t,t) - \epsilon_t}_2^2 \right].
$$

Putting everything together, we can approximate the desired gradient term as

$$
\begin{aligned}
    &\pderiv{}{\theta} \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \right] \\
    &= \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \cdot \left(\nabla_\theta \ln p_\theta(\hat{y})\right)^\top \right] \\
    &\approx \E_{p_\theta(\hat{y})} \left[ \nabla_z f(\hat{y}, z_\theta) \cdot \left( \nabla_\theta \text{ELBO}(\theta; \hat{y}) \right)^\top \right] \\
    &\approx \E_{p_\theta(\hat{y})} \left[
        \nabla_z f(\hat{y}, z_\theta) \cdot
        \E_{t \in [T],\,\epsilon_t \sim \Gaussian(0,I)} \left[ \nabla_\theta \norm{\hat\epsilon_\theta(y_t,t) - \epsilon_t}_2^2 \right]^\top
    \right].
\end{aligned}$$

Finally, we can plug this approximation into the general gradient expression derived earlier to obtain an approximate gradient of the expected decision cost $$F(\theta)$$:

$$\begin{aligned}
    \deriv{F}{\theta}(\theta)
    &\approx - \begin{bmatrix}
        \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \right] & \zero_{1 \times d_h}
    \end{bmatrix} \cdot
    J^{-1} \cdot
    \begin{bmatrix}
        \E_{p_\theta(\hat{y})} \left[
        \nabla_z f(\hat{y}, z_\theta) \cdot
        \E_{t \in [T],\,\epsilon_t \sim \Gaussian(0,I)} \left[ \nabla_\theta \norm{\hat\epsilon_\theta(y_t,t) - \epsilon_t}_2^2 \right]^\top
        \right]
        \\ \zero_{d_h \times d_\theta}
    \end{bmatrix}
    \\
    &= \E_{p_\theta(\hat{y})} \Bigg[
        \underbrace{- \begin{bmatrix}
            \E_{\Pcal(y)} \left[ \pderiv{f}{z}(y, z_\theta) \right] & \zero_{1 \times d_h}
        \end{bmatrix} \cdot
        J^{-1} \cdot \begin{bmatrix} \nabla_z f(\hat{y}, z_\theta) \\ \zero_{d_h} \end{bmatrix}}_{:= w_\theta(\hat{y})} \cdot
        \E_{t \in [T],\,\epsilon_t \sim \Gaussian(0,I)} \left[ \nabla_\theta \norm{\hat\epsilon_\theta(y_t,t) - \epsilon_t}_2^2 \right]^\top
    \Bigg] \\
    &= \E_{p_\theta(\hat{y})} \left[
        w_\theta(\hat{y}) \cdot
        \E_{t \in [T],\,\epsilon_t \sim \Gaussian(0,I)} \left[ \nabla_\theta \norm{\hat\epsilon_\theta(y_t,t) - \epsilon_t}_2^2 \right]^\top
    \right].
\end{aligned}$$

In practice, all of the expectations above are approximated with Monte Carlo sampling. Given:
- a true data sample $$y \sim \Pcal$$ from the true distribution;
- $$M$$ samples $$\hat{y}_1, \dotsc, \hat{y}_M \iid p_\theta$$ from the generative model;
- for each sample $$\hat{y}_m$$,
    - $$K$$ time steps $$t_{m,1}, \dotsc, t_{m,K} \iid \Uniform(\{1, \dotsc, T\})$$;
    - $$K$$ independent Gaussian noise samples $$\epsilon_{m,k} \iid \Gaussian(0,I)$$, for $$k = 1, \dotsc, K$$;
    - $$K$$ noisy samples $$\bar{y}_{m,k} = \sqrt{\bar\alpha_{t_{m,k}}} \hat{y}_m + \sqrt{1 - \bar\alpha_{t_{m,k}}} \epsilon_{m,k}$$, for $$k = 1, \dotsc, K$$;

we can approximate the overall expected decision cost gradient as follows:

$$
\begin{aligned}
    z_\theta &\approx \argmin_z \
    \frac{1}{M} \sum_{m=1}^M f(\hat{y}_m, z)
    \quad\text{s.t.}\quad h(z) \leq 0,
    \\
    \lambda_\theta &\approx \text{corresponding optimal Lagrange multipliers},
    \\
    J &\approx \begin{bmatrix}
        \frac{1}{M} \sum_{m=1}^M \nabla_{zz}^2 f(\hat{y}_m, z_\theta)
            + \nabla^2_{zz} (\lambda_\theta^\top h(z_\theta)) & \nabla_z h(z_\theta) \\
        \diag(\lambda_\theta)\, \pderiv{h}{z}(z_\theta) & \diag(h(z_\theta))
    \end{bmatrix},
    \\
    w_\theta(\hat{y}_m) &\approx -\begin{bmatrix}
        \pderiv{f}{z}(y, z_\theta) & \zero_{1 \times d_h}
    \end{bmatrix} \cdot
    J^{-1} \cdot \begin{bmatrix} \nabla_z f(\hat{y}_m, z_\theta) \\ \zero_{d_h} \end{bmatrix},
        & m = 1, \dotsc, M,
    \\
    \nabla_\theta F(\theta)
    &\approx \frac{1}{M} \sum_{m=1}^M w_\theta(\hat{y}_m) \cdot
        \frac{1}{K} \sum_{k=1}^K \nabla_\theta \norm{\hat\epsilon_\theta(\bar{y}_{m,k}, t_{m,k}) - \epsilon_{m,k}}_2^2.
\end{aligned}$$

We summarize the full Diffusion DFL training algorithm below, now written with $$x$$-conditional diffusion models for generality.

**Diffusion DFL training algorithm**

As in the reparameterization trick approach, assume that we have closed-form expressions for $$\nabla_{zz}^2 f(y,z)$$, $$\nabla_{zz}^2 (\lambda^\top h(x,z))$$, $$\nabla_z h(x,z)$$, and $$\nabla_z f(y,z)$$, so that we can compute $$H$$, $$G$$, and $$J$$ as needed.

For each minibatch of data examples $$(x_1, y_1), \dotsc, (x_N, y_N) \iid \Pcal$$:

1. For each $$n = 1, \dotsc, N$$:
    1. With gradient tracking disabled (`torch.no_grad()`)

        1. Draw $$M$$ samples $$\hat{y}_1, \dotsc, \hat{y}_M \iid p_\theta(\cdot \mid x_n)$$ from the conditional diffusion model given context $$x_n$$.

        2. Compute the stochastic optimization solution

            $$
            z_\theta(x_n) \approx \argmin_z \
            \frac{1}{M} \sum_{m=1}^M f(\hat{y}_m, z)
            \quad\text{s.t.}\quad h(x_n, z) \leq 0,
            $$

            and the corresponding optimal Lagrange multipliers $$\lambda_\theta$$.
        
        3. Compute the matrix

            $$
            J := \begin{bmatrix}
                \frac{1}{M} \sum_{m=1}^M \nabla_{zz}^2 f(\hat{y}_m, z_\theta)
                    + \nabla^2_{zz} (\lambda_\theta^\top h(x_n, z_\theta)) & \nabla_z h(x_n, z_\theta) \\
                \diag(\lambda_\theta)\, \pderiv{h}{z}(x_n, z_\theta) & \diag(h(x_n, z_\theta))
            \end{bmatrix}.
            $$
        
        4. For each $$m = 1, \dotsc, M$$:
            1. Compute the scalar weight

                $$
                w(\hat{y}_m) := -\begin{bmatrix}
                    \pderiv{f}{z}(y_n, z_\theta) & \zero_{1 \times d_h}
                \end{bmatrix} \cdot
                J^{-1} \cdot \begin{bmatrix} \nabla_z f(\hat{y}_m, z_\theta) \\ \zero_{d_h} \end{bmatrix}.
                $$
            
            2. Draw $$K$$ time steps $$t_{m,1}, \dotsc, t_{m,K} \iid \Uniform(\{1, \dotsc, T\})$$ and corresponding noise vectors $$\epsilon_{m,1}, \dotsc, \epsilon_{m,K} \iid \Gaussian(0,I)$$.

            3. Compute the noisy samples $$\bar{y}_{m,k} = \sqrt{\bar\alpha_{t_{m,k}}} \hat{y}_m + \sqrt{1 - \bar\alpha_{t_{m,k}}} \epsilon_{m,k}$$ for $$k = 1, \dotsc, K$$.

    2. With gradient tracking enabled (`torch.enable_grad()`), compute the surrogate objective

        $$
        F_n(\theta) := \frac{1}{M} \sum_{m=1}^M w(\hat{y}_m) \cdot \frac{1}{K} \sum_{k=1}^K \norm{\hat\epsilon_\theta(\bar{y}_{m,k}, t_{m,k}) - \epsilon_{m,k}}_2^2.
        $$
    
2. Compute the surrogate expected decision cost for the minibatch: $$F(\theta) = \frac{1}{N} \sum_{n=1}^N F_n(\theta)$$.
3. Backpropagate gradients ($$F$$.backward()) and take a gradient step.

**Memory usage advantages:** The score function estimator approach has significant memory usage advantages compared to the reparameterization trick approach. Specifically, the score function estimator does not require storing intermediate diffusion steps for backpropagation, since the gradient of the ELBO can be computed using only the current noisy sample $$\bar{y}_{m,k}$$ at each time step. Thus, the "effective batch size" for the score function approach is $$O(NMK)$$, compared to $$O(NMT)$$ for the reparameterization trick. Experimentally, it is often sufficient to use a small number of time steps $$K$$ (e.g., 10 or 50) to obtain good gradient estimates. In contrast, diffusion models often require a large number of diffusion steps $$T$$ (e.g., 1000) for high-quality samples. Thus, with $$K \ll T$$, the score function estimator approach will use significantly less memory than the reparameterization trick.