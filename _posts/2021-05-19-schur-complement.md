---
title: Schur Complements and the Matrix Inversion Lemma
layout: post
use_math: true
use_toc: true
last_updated: 2021-06-18
tags: [math]
excerpt: I prove key properties of Schur Complements and use them to derive the matrix inversion lemma.
---

$$
\newcommand{\C}{\mathbb{C}}  % complex numbers
\newcommand{\F}{\mathbb{F}}  % field
\newcommand{\Sym}{\mathbb{S}}  % symmetric matrices
\newcommand{\norm}[1]{\|#1\|}  % norm
\newcommand{\spanset}[1]{\spans\left\{#1\right\}}  % span
\newcommand{\zero}{\mathbf{0}}  % zeros vector
\DeclareMathOperator{\det}{det}  % determinant
\DeclareMathOperator{\diag}{diag}  % diagonal
\DeclareMathOperator{\null}{null}  % null
\DeclareMathOperator{\rank}{rank}  % rank
\DeclareMathOperator{\range}{range}  % range
\DeclareMathOperator{\spans}{span}  % span
$$

## Preliminaries

The post assumes standard linear algebra knowledge at the level presented in S. Axler's *Linear Algebra Done Right, 3e* (LADR). All results in this post apply to both real and complex-valued matrices, unless otherwise specified.
* $$\F$$ stands for either $$\R$$ or $$\C$$.
* $$I_n$$ denotes the $$n \times n$$ identity matrix.
* $$\Sym^n$$ denotes the vector space of symmetric $$n \times n$$ real matrices.
* $$\zero$$ denotes an all-zero vector or matrix, whereas 0 denotes scalar zero.


## Summary

I summarize the key results here. Consider a square matrix with block partition

$$ M = \begin{bmatrix} A & B \\ C & D \end{bmatrix}. $$

Let $$M/A = D - C A^{-1} B$$ and $$M/D = A - B D^{-1} C$$ denote the Schur complements.

If $$A$$ is invertible, then $$M$$ is invertible $$\iff \ M/A$$ is invertible, and either implies that

$$
    M^{-1} = \begin{bmatrix}
        A^{-1} + A^{-1} B (M/A)^{-1} C A^{-1}  &  -A^{-1} B (M/A)^{-1} \\
        -(M/A)^{-1} C A^{-1}                   &  (M/A)^{-1}
    \end{bmatrix}.
$$

Similarly, if $$D$$ is invertible, then $$M$$ is invertible $$\iff \ M/D$$ is invertible, and either implies that

$$
    M^{-1} = \begin{bmatrix}
        (M/D)^{-1}            &  -(M/D)^{-1} B D^{-1} \\
        -D^{-1} C (M/D)^{-1}  &  D^{-1} + D^{-1} C (M/D)^{-1} B D^{-1}
    \end{bmatrix}.
$$

These two results combine to give the matrix inversion lemma, which states that if $$A, D$$ are invertible and any of ($$M, M/D, M/A$$) are invertible, then:

* all of $$M$$, $$M/A$$, and $$M/D$$ are invertible;
* $$(M/A)^{-1} = D^{-1} + D^{-1} C (M/D)^{-1} B D^{-1}$$;
* $$(M/D)^{-1} = A^{-1} + A^{-1} B (M/A)^{-1} C A^{-1}$$.

Finally, the positive (semi-)definiteness of $$M \in \Sym^n$$ is related to the positive (semi-)definiteness of its Schur complements by the following properties:

1. $$ M \succ 0 \ \iff \ A, (M/A) \succ 0 \ \iff \ D, (M/D) \succ 0 $$.
2. If $$A \succ 0$$, then $$ M \succeq 0 \ \iff \ (M/A) \succeq 0 $$.
3. If $$D \succ 0$$, then $$ M \succeq 0 \ \iff \ (M/D) \succeq 0 $$.

If we consider generalized Schur complements (replacing $$A^{-1}$$ and $$D^{-1}$$ with their Moore-Penrose pseudoinverses), then the following conditions are equivalent for $$M \in \Sym^n$$:

1. $$M \succeq 0$$.
2. $$A \succeq 0$$, $$(I - A A^\dagger) B = \zero$$, $$D - B^\top A^\dagger B \succeq 0$$.
3. $$D \succeq 0$$, $$(I - D D^\dagger) B^\top = \zero$$, $$A - B D^\dagger B^\top \succeq 0$$.


## Schur Complements

### Definition

Consider a square matrix $$M$$ of size $$(n+m) \times (n+m)$$, partitioned as

$$ M = \begin{bmatrix} A & B \\ C & D \end{bmatrix} $$

where $$A \in \F^{n \times n}$$, $$B \in \F^{n \times m}$$, $$C \in \F^{m \times n}$$, and $$D \in \F^{m \times m}$$.

If $$A$$ is invertible, the **Schur complement of the block $$A$$ of the matrix $$M$$** is defined as the $$m \times m$$ matrix

$$ M/A = D - C A^{-1} B. $$

Similarly, if $$D$$ is invertible, the **Schur complement of the block $$D$$ of the matrix $$M$$** is defined as the $$n \times n$$ matrix

$$ M/D = A - B D^{-1} C. $$


### Key Properties

All of the properties of Schur complements have analogous results when considering block $$A$$ and block $$D$$.

**Lemma (Factorization using Schur complements)**: If $$A$$ is invertible, then $$M$$ can be factorized as

$$
    M = \begin{bmatrix} I_n & \zero \\ C A^{-1} & I_m \end{bmatrix}
        \begin{bmatrix} A & \zero \\ \zero & M/A \end{bmatrix}
        \begin{bmatrix} I_n & A^{-1} B \\ \zero & I_m \end{bmatrix}.
$$

If $$D$$ is invertible, then $$M$$ can be factorized as

$$
    M = \begin{bmatrix} I_n & B D^{-1} \\ \zero & I_m \end{bmatrix}
        \begin{bmatrix} M/D & \zero \\ \zero & D \end{bmatrix}
        \begin{bmatrix} I_n & \zero \\ D^{-1} C & I_m \end{bmatrix}.
$$

Both of the equalities can be seen by directly multiplying the matrix factors.

**Lemma (Determinant of Block Matrix)**: If $$A$$ is invertible, then $$\det(M) = \det(A) \det(M/A)$$. Similarly, if $$D$$ is invertible, then $$\det(M) = \det(D) \det(M/D)$$.

<details markdown="block"><summary>Proof</summary>

The proof is a direct application of three properties of determinants to the factorization of $$M$$ given in the previous lemma.
* The determinant of the product of two matrices is the product of their determinants: $$\det(AB) = \det(A) \det(B)$$. (LADR 10.40)
* The determinant of a triangular matrix is the product of the diagonal entries. ([StackExchange](https://math.stackexchange.com/a/2013136))
* The determinant of a block-diagonal matrix is the product of the determinants of the individual blocks. ([StackExchange](https://math.stackexchange.com/a/1219331))

The left and right matrices in each factorization of $$M$$ are triangular with 1s on the diagonal, so their determinants are 1. The middle matrix in each factorization of $$M$$ is block-diagonal.

</details>

**Theorem (Invertibility of Schur complement)**: If $$A$$ is invertible, then

$$ M \text{ is invertible} \ \iff \ M/A \text{ is invertible,} $$

and either implies that

$$
    M^{-1} = \begin{bmatrix}
        A^{-1} + A^{-1} B (M/A)^{-1} C A^{-1}  &  -A^{-1} B (M/A)^{-1} \\
        -(M/A)^{-1} C A^{-1}                   &  (M/A)^{-1}
    \end{bmatrix}.
$$

Similarly, if $$D$$ is invertible, then

$$ M \text{ is invertible} \ \iff \ M/D \text{ is invertible,} $$

and either implies that

$$
    M^{-1} = \begin{bmatrix}
        (M/D)^{-1}            &  -(M/D)^{-1} B D^{-1} \\
        -D^{-1} C (M/D)^{-1}  &  D^{-1} + D^{-1} C (M/D)^{-1} B D^{-1}
    \end{bmatrix}.
$$

<details markdown="block"><summary>Proof</summary>

A matrix is invertible if and only if its determinant is nonzero (LADR 10.24 and 10.42). Combining this fact with the previous lemma yields the desired result.

Furthermore, the proof of the previous lemma shows that if $$A$$ and $$M/A$$ are invertible, then all 3 matrices in the factorization of $$M$$ have nonzero determinant and are therefore invertible. This naturally leads to a derivation of the inverse of $$M$$:

$$
\begin{aligned}
    M^{-1}
    &= \begin{bmatrix} I_n & A^{-1} B \\ \zero & I_m \end{bmatrix}^{-1}
       \begin{bmatrix} A & \zero \\ \zero & M/A \end{bmatrix}^{-1}
       \begin{bmatrix} I_n & \zero \\ C A^{-1} & I_m \end{bmatrix}^{-1} \\
    &= \begin{bmatrix} I_n & -A^{-1} B \\ \zero & I_m \end{bmatrix}
       \begin{bmatrix} A^{-1} & \zero \\ \zero & (M/A)^{-1} \end{bmatrix}
       \begin{bmatrix} I_n & \zero \\ -C A^{-1} & I_m \end{bmatrix} \\
    &= \begin{bmatrix}
        A^{-1} + A^{-1} B (M/A)^{-1} C A^{-1}  &  -A^{-1} B (M/A)^{-1} \\
        -(M/A)^{-1} C A^{-1}                   &  (M/A)^{-1}
       \end{bmatrix}
\end{aligned}
$$

Similarly, if $$D$$ and $$M/D$$ are invertible, then the inverse of $$M$$ can be derived as

$$
\begin{aligned}
    M^{-1}
    &= \begin{bmatrix} I_n & \zero \\ D^{-1} C & I_m \end{bmatrix}^{-1}
       \begin{bmatrix} M/D & \zero \\ \zero & D \end{bmatrix}^{-1}
       \begin{bmatrix} I_n & B D^{-1} \\ \zero & I_m \end{bmatrix}^{-1} \\
    &= \begin{bmatrix} I_n & \zero \\ -D^{-1} C & I_m \end{bmatrix}
       \begin{bmatrix} (M/D)^{-1} & \zero \\ \zero & D^{-1} \end{bmatrix}
       \begin{bmatrix} I_n & -B D^{-1} \\ \zero & I_m \end{bmatrix} \\
    &= \begin{bmatrix}
        (M/D)^{-1}            &  -(M/D)^{-1} B D^{-1} \\
        -D^{-1} C (M/D)^{-1}  &  D^{-1} + D^{-1} C (M/D)^{-1} B D^{-1}
       \end{bmatrix}
\end{aligned}.
$$

Below, I also present an alternative derivation of the inverse of $$M$$. Suppose that $$A$$ and $$M/A$$ are invertible, and consider the linear equation

$$
    M \begin{bmatrix} x \\ y \end{bmatrix}
    = \begin{bmatrix} a \\ b \end{bmatrix}.
$$

To determine $$M^{-1}$$, we solve for the coefficients that express $$x$$ and $$y$$ in terms of $$a$$ and $$b$$. The linear equation can be split into

$$
\begin{aligned}
    Ax + By &= a \\
    Cx + Dy &= b.
\end{aligned}
$$

Since $$A$$ is invertible, $$x = A^{-1} (a - By)$$. Plugging this into the second equation and using the assumption that $$M/A$$ is invertible yields

$$
\begin{aligned}
    b &= C A^{-1} (a - By) + Dy \\
    &= C A^{-1} a + (D - C A^{-1} B) y \\
    &= C A^{-1} a + (M/A) y
    \\
    y &= (M/A)^{-1} b - (M/A)^{-1} C A^{-1} a.
\end{aligned}
$$

Plugging this back into the equation for $$x$$ yields

$$
\begin{aligned}
    x &= A^{-1} a - A^{-1} B (M/A)^{-1} b + A^{-1} B (M/A)^{-1} C A^{-1} a \\
    &= (A^{-1} + A^{-1} B (M/A)^{-1} C A^{-1}) a - A^{-1} B (M/A)^{-1} b.
\end{aligned}
$$

In matrix form,

$$
    \begin{bmatrix} x \\ y \end{bmatrix}
    = \underbrace{\begin{bmatrix}
        A^{-1} + A^{-1} B (M/A)^{-1} C A^{-1}  &  -A^{-1} B (M/A)^{-1} \\
        -(M/A)^{-1} C A^{-1}                   &  (M/A)^{-1}
      \end{bmatrix}}_{M^{-1}}
      \begin{bmatrix} a \\ b \end{bmatrix}.
$$

Since this equation holds for arbitrary $$a,b$$, the underbraced matrix must be $$M^{-1}$$.

</details>


### Matrix Inversion Lemma

The matrix inversion lemma is a corollary of the previous theorem.

<section class="callout" markdown="block">

**Matrix Inversion Lemma**: If $$A$$ and $$D$$ are invertible, and any of ($$M$$, $$M/A$$, or $$M/D$$) are invertible, then all of $$M$$, $$M/A$$, and $$M/D$$ are invertible. Furthermore,

$$
\begin{aligned}
    M^{-1}
    &= \begin{bmatrix}
        A^{-1} + A^{-1} B (M/A)^{-1} C A^{-1}  &  -A^{-1} B (M/A)^{-1} \\
        -(M/A)^{-1} C A^{-1}                   &  (M/A)^{-1}
       \end{bmatrix}
    \\
    &= \begin{bmatrix}
        (M/D)^{-1}            &  -(M/D)^{-1} B D^{-1} \\
        -D^{-1} C (M/D)^{-1}  &  D^{-1} + D^{-1} C (M/D)^{-1} B D^{-1}
       \end{bmatrix}.
\end{aligned}
$$

Since a matrix inverse is unique, equating the two expressions for $$M^{-1}$$ yields the identities

$$
\begin{aligned}
    (M/A)^{-1} &= D^{-1} + D^{-1} C (M/D)^{-1} B D^{-1} \\
    (M/D)^{-1} &= A^{-1} + A^{-1} B (M/A)^{-1} C A^{-1}.
\end{aligned}
$$

</section>

In fact, since there are 2 valid ways to write out each block of $$M^{-1}$$, this provides $$2^4 = 16$$ valid expressions for $$M^{-1}$$.

Note that the identities in the matrix inversion lemma do not actually require constructing the full block matrix $$M$$. Thus, the lemma is often stated without explicitly constructing $$M$$, and instead directly considers arbitrary matrices $$A \in \F^{n \times n}$$, $$B \in \F^{n \times m}$$, $$C \in \F^{m \times n}$$, and $$D \in \F^{m \times m}$$.

<section class="callout" markdown="block">
**Matrix Inversion Lemma (alternate form)**: For any invertible matrices $$A$$ and $$D$$ and any matrices $$B$$ and $$C$$, if either $$(D - C A^{-1} B)$$ or $$(A - B D^{-1} C)$$ is invertible, then both are invertible and are related by the identities

$$
\begin{aligned}
    (D - C A^{-1} B)^{-1} &= D^{-1} + D^{-1} C (A - B D^{-1} C)^{-1} B D^{-1} \\
    (A - B D^{-1} C)^{-1} &= A^{-1} + A^{-1} B (D - C A^{-1} B)^{-1} C A^{-1}.
\end{aligned}
$$

</section>

If we substitute $$\bar{C} = -C$$ and $$\bar{D} = D^{-1}$$ into the matrix inversion lemma, then we arrive at the Woodbury matrix identity.

<section class="callout" markdown="block">

**Woodbury matrix identity**: For any invertible matrices $$A$$ and $$\bar{D}$$ and any matrices $$B$$ and $$\bar{C}$$, if either $$(A + B \bar{D} \bar{C})$$ or $$(\bar{D}^{-1} + \bar{C} A^{-1} B)$$ is invertible, then both are invertible and are related by

$$
    (A + B \bar{D} \bar{C})^{-1}
    = A^{-1} - A^{-1} B (\bar{D}^{-1} + \bar{C} A^{-1} B)^{-1} \bar{C} A^{-1}.
$$

</section>

Some texts such as Boyd's *Convex Optimization* book (Appendix C.4.3) substitute $$D = -I_m$$ (which is invertible) into the matrix inversion lemma.

<section class="callout" markdown="block">

**Woodbury matrix identity (simpler form)**: For any invertible matrix $$A$$, if either $$(I + C A^{-1} B)$$ or $$(A + BC)$$ is invertible, then both are invertible and are related by

$$
    (A + BC)^{-1}
    = A^{-1} - A^{-1} B (I + C A^{-1} B)^{-1} C A^{-1}.
$$

</section>

Finally, the special case of the matrix inversion lemma where $$A \in \R^{n \times n}$$, $$B = u \in \R^n$$, $$C = v^\top \in \R^{1 \times n}$$, and $$D = D^{-1} = -1$$ is known as the Sherman-Morrison formula.

<section class="callout" markdown="block">

**Sherman-Morrison formula**: For any invertible matrix $$A \in \R^{n \times n}$$ and vectors $$u, v \in \R^n$$,

$$ (A + uv^\top) \text{ is invertible} \ \iff \ 1 + v^\top A^{-1} u \neq 0 $$

and if either holds, then

$$
    (A + uv^\top)^{-1}
    = A^{-1} - \frac{A^{-1} u v^\top A^{-1}}{1 + v^\top A^{-1} u}.
$$

</section>

**Discussion**

The matrix inversion lemma naturally leads to the following question: if $$A$$ and $$D$$ are invertible, do we actually need the condition that one of ($$M$$, $$M/A$$, or $$M/D$$) is invertible in order for the lemma to hold? The answer is yes, as shown by the following counterexample.

Consider the all-ones matrix $$M = \begin{bmatrix} 1 & 1 \\ 1 & 1 \end{bmatrix}.$$ Clearly $$A = D = 1$$ is invertible, but $$M$$ is not invertible because it is not full-rank.

On the other hand, there also exist invertible matrices such as

$$
    M = M^{-1}
    = \begin{bmatrix} 0 & 1 \\ 1 & 0 \end{bmatrix}
$$

where neither $$A$$ nor $$D$$ are invertible (and therefore $$M/A$$ and $$M/D$$ are undefined). In other words, the matrix inversion lemma may be useful in many settings, but it does not apply to all invertible matrices.


### Characterizing Symmetric Positive Definite Matrices

This section considers the special case where $$M$$ is real and symmetric (i.e., $$C = B^\top$$):

$$ M = \begin{bmatrix} A & B \\ B^\top & D \end{bmatrix}. $$

Then by the factorization lemma above, if $$A$$ is invertible, then

$$
    M = \begin{bmatrix} I_n & \zero \\ B^\top A^{-1} & I_m \end{bmatrix}
        \begin{bmatrix} A & \zero \\ \zero & M/A \end{bmatrix}
        \begin{bmatrix} I_n & A^{-1} B \\ \zero & I_m \end{bmatrix}.
$$

If $$D$$ is invertible, then

$$
    M = \begin{bmatrix} I_n & B D^{-1} \\ \zero & I_m \end{bmatrix}
        \begin{bmatrix} M/D & \zero \\ \zero & D \end{bmatrix}
        \begin{bmatrix} I_n & \zero \\ D^{-1} B^\top & I_m \end{bmatrix}.
$$

The following function $$f: \R^n \times \R^m \to \R$$ is useful for our analysis of $$M$$:

$$
\begin{aligned}
    f(x,y)
    &= [x^\top \ y^\top]
       M
       \begin{bmatrix} x \\ y \end{bmatrix} \\
    &= x^\top A x + 2 x^\top B y + y^\top D y
    \\
    \nabla f(x,y) &= 2 M \begin{bmatrix} x \\ y \end{bmatrix}
    \\
    \nabla^2 f(x,y) &= 2M.
\end{aligned}
$$

Note that this implies

$$
\begin{aligned}
    \nabla_x f(x,y) &= 2Ax + 2By         &  \nabla^2_x f(x,y) &= 2A \\
    \nabla_y f(x,y) &= 2Dy + 2 B^\top x  &  \nabla^2_y f(x,y) &= 2D
\end{aligned}
$$

**Lemma (Positive definite diagonal blocks)**: If $$M \succ 0$$, then $$A, D \succ 0$$. If $$M \succeq 0$$, then $$A, D \succeq 0$$.

<details markdown="block"><summary>Proof</summary>

Suppose $$M \succ 0$$, so by definition $$\forall (x,y) \neq \zero: \ f(x,y) > 0$$.

First, consider $$y = \zero$$. Then $$f(x, y=\zero) = x^\top A x > 0$$ for all $$x \neq \zero$$. This shows $$A \succ 0$$.

Likewise, consider $$x = \zero$$. Then $$f(x=\zero, y) = y^\top D y > 0$$ for all $$y \neq \zero$$. This shows $$D \succ 0$$.

The proof for the semidefinite case is nearly identical, where $$>$$ is replaced with $$\geq$$.

</details>

**Theorem (Conditions for Positive Definiteness):**
1. $$ M \succ 0 \ \iff \ A, (M/A) \succ 0 \ \iff \ D, (M/D) \succ 0 $$.
2. If $$A \succ 0$$, then $$ M \succeq 0 \ \iff \ (M/A) \succeq 0 $$.
3. If $$D \succ 0$$, then $$ M \succeq 0 \ \iff \ (M/D) \succeq 0 $$.

<details markdown="block"><summary>Proof</summary>

We assert the following facts without proof:
1. For any symmetric matrix $$P$$ and any invertible matrix $$N$$, $$N P N^\top$$ is symmetric. Furthermore, $$P \succ 0 \iff N P N^\top \succ 0$$. Likewise, $$P \succeq 0 \iff N P N^\top \succeq 0$$.
2. A block diagonal matrix is positive definite if and only if each diagonal block is positive definite. Likewise, a block diagonal matrix is positive semidefinite if and only if each diagonal block is positive semidefinite.

First, suppose $$A \succ 0$$. Then by the factorization lemma, $$M = N P N^\top$$ where

$$
\begin{aligned}
    N      &= \begin{bmatrix} I_n & \zero \\  B^\top A^{-1} & I_m \end{bmatrix} \\
    N^{-1} &= \begin{bmatrix} I_n & \zero \\ -B^\top A^{-1} & I_m \end{bmatrix} \\
    P      &= \begin{bmatrix} A & \zero \\ \zero & M/A \end{bmatrix}.
\end{aligned}
$$

By the facts listed above, $$M = N P N^\top \succeq 0 \ \iff \ P \succeq 0 \ \iff \ A, (M/A) \succeq 0$$. This proves (2).

If both $$A, (M/A) \succ 0$$, then $$P \succ 0 \implies M = N P N^\top \succ 0$$. If $$M \succ 0$$, then by the previous lemma, $$A \succ 0$$, so the $$M = N P N^\top$$ factorization applies. Thus, $$M = N P N^\top \succ 0 \implies P \succ 0 \implies (M/A) \succ 0$$, which proves the first part of (1).

Using the other factorization of $$M$$ (when $$D \succ 0$$) proves both (3) and the second part of (1).

*Source*: See Propositions 16.1/16.2 in Gallier's *Geometric Methods and Applications* or Propositions 2.1/2.2 in Gallier's "The Schur Complement" ([References](#references)).

</details>

<details markdown="block"><summary>Proof (using convexity)</summary>

*Note*: This proof assumes knowledge about convex functions. See, e.g., *Convex Optimization* by Boyd ([References](#references)).

First, suppose $$A \succ 0$$. Since $$\nabla_x^2 f(x,y) = 2A \succ 0$$, $$f$$ is convex in $$x$$. For fixed $$y$$, $$f$$ is minimized by the value $$x_*$$ such that

$$ \nabla_x f(x_*, y) = 2Ax_* + 2By = \zero $$

so $$x_* = -A^{-1} By$$. Plugging this value into $$f$$ gives

$$
\begin{aligned}
    f(x_*, y)
    &= (A^{-1} By)^\top By - 2 (A^{-1} By)^\top By + y^\top D y \\
    &= y^\top (D - B^\top A^{-1} B) y \\
    &= y^\top (M/A) y.
\end{aligned}
$$

Thus, if $$A \succ 0$$, then

$$
\begin{aligned}
    M \succ 0
    &\iff \forall x,y: f(x,y) \geq f(x_*,y) > 0 \\
    &\iff (M/A) \succ 0.
\end{aligned}
$$

Since $$M \succ 0 \implies A \succ 0$$ (by the previous lemma), this proves the first part of (1). Replacing $$(\succ, >)$$ with $$(\succeq, \geq)$$ in the statement above gives (2).

The proof for (3) and the second part of (1) is similar. Suppose $$D \succ 0$$. Then for fixed $$x$$, $$f$$ is minimized by $$y_* = -D^{-1} B^\top x$$. Plugging this into $$f$$ gives $$ f(x,y_*) = x^\top (M/D) x$$. Then

$$
\begin{aligned}
    M \succ 0
    &\iff \forall x,y: f(x,y) \geq f(x,y_*) > 0 \\
    &\iff (M/D) \succ 0.
\end{aligned}
$$

Since $$M \succ 0 \implies D \succ 0$$ (by the previous lemma), this proves the second part of (1). Replacing $$(\succ, >)$$ with $$(\succeq, \geq)$$ in the statement above gives (3).

</details>


## Generalized Schur Complements

This section explores generalized Schur complements when $$A$$ and $$D$$ are not invertible. To do so, we rely on their pseudoinverses, which we define in terms of their singular value decomposition (SVD).

### SVD and Pseudoinverses

Every matrix $$P \in \F^{n \times m}$$ with $$\rank P = r$$ has a **compact SVD** $$P = U \Sigma V^*$$ where

* $$U \in \F^{n \times r}$$ and $$V \in \F^{m \times r}$$ have orthonormal columns;
* $$\Sigma = \diag(\sigma_1, \dotsc, \sigma_r) \in \Sym^r$$ is a positive definite diagonal matrix with $$\sigma_1 \geq \dotsb \geq \sigma_r > 0$$.

This compact SVD can be extended to a **full SVD**

$$
\begin{alignat*}{4}
    P &= \bar{U} \bar{\Sigma} \bar{V}^* \\
    \bar{U} &= \begin{bmatrix} U & u_{r+1}, \dotsc, u_n \end{bmatrix}
        &&\in \F^{n \times n} \\
    \bar{\Sigma} &= \begin{bmatrix} \Sigma & \zero \\ \zero & \zero_{(n-r) \times (m-r)} \end{bmatrix}
        &&\in \R^{n \times m} \\
    \bar{V} &= \begin{bmatrix} V & v_{r+1}, \dotsc, v_m \end{bmatrix}
        &&\in \F^{m \times m}
\end{alignat*}
$$

where $$\bar{U}$$, $$\bar{V}$$ are unitary matrices.

The **Moore-Penrose pseudoinverse** ([Wikipedia](https://en.wikipedia.org/wiki/Moore%E2%80%93Penrose_inverse)) of $$P$$ is defined as

$$
    P^\dagger
    = V \Sigma^{-1} U^*
    \in \F^{m \times n}.
$$

Using the compact SVD of $$\bar{\Sigma}$$, we can derive its pseudoinverse

$$
\begin{aligned}
    \bar{\Sigma}
    &= \begin{bmatrix} I_r \\ \zero_{(n-r) \times r} \end{bmatrix}
       \Sigma
       \begin{bmatrix} I_r & \zero_{r \times (m-r)} \end{bmatrix}
    \\
    \bar{\Sigma}^\dagger
    &= \begin{bmatrix} I_r \\ \zero_{(m-r) \times r} \end{bmatrix}
       \Sigma^{-1}
       \begin{bmatrix} I_r & \zero_{r \times (n-r)} \end{bmatrix} \\
    &= \begin{bmatrix} \Sigma^{-1} & \zero \\ \zero & \zero_{(m-r) \times (n-r)} \end{bmatrix}.
\end{aligned}
$$

Thus, the pseudoinverse of $$P$$ can also be expressed in terms of its full SVD:

$$
\begin{aligned}
    P^\dagger
    &= \bar{V} \bar{\Sigma}^\dagger \bar{U}^* \\
    &= \begin{bmatrix} V \Sigma^{-1} & \zero_{m \times (n-r)} \end{bmatrix} \bar{U}^* \\
    &= V \Sigma^{-1} U^*.
\end{aligned}
$$

The pseudoinverse satisfies

$$
\begin{aligned}
    P P^\dagger P
    &= (U \Sigma V^*) (V \Sigma^{-1} U^*) (U \Sigma V^*) \\
    &= U \Sigma I_r \Sigma^{-1} I_r \Sigma V^* \\
    &= U \Sigma V^* = P
    \\
    P^\dagger P P^\dagger
    &= (V \Sigma^{-1} U^*) (U \Sigma V^*) (V \Sigma^{-1} U^*) \\
    &= V \Sigma^{-1} I_r \Sigma I_r \Sigma^{-1} U^* \\
    &= V \Sigma^{-1} U^* = P^\dagger.
\end{aligned}
$$

Furthermore, if $$P$$ is Hermitian, then $$P^\dagger$$ is also Hermitian:

$$
\begin{aligned}
    P^* &= (U \Sigma V^*)^* = V \Sigma U^* \\
    P^\dagger &= (P^*)^\dagger = U \Sigma^{-1} V^* = (V \Sigma^{-1} U^*)^* = (P^\dagger)^*
\end{aligned}
$$

**Lemma (Range of $$P$$ and $$P P^\dagger$$)**: For any $$P \in \F^{n \times m}$$ and $$y \in \F^n$$,

$$ y \in \range P \iff P P^\dagger y = y. $$

It is sometimes convenient to write this as $$(I - P P^\dagger) y = \zero$$. A corollary is that $$\range P = \range P P^\dagger$$.

<details markdown="block"><summary>Proof</summary>

First, suppose $$y \in \range P$$, so there exists $$x \in \F^m$$ such that $$Px = y$$. Then

$$ P P^\dagger y = P P^\dagger P x = P x = y. $$

Next, suppose $$P (P^\dagger y) = y$$. Clearly $$y \in \range P$$.

It is obvious that $$\range P P^\dagger \subseteq \range P$$. But

$$
    y \in \range P
    \iff P P^\dagger y = y
    \implies y \in \range P P^\dagger,
$$

so $$\range P \subseteq \range P P^\dagger$$.

</details>


### Definition and Factorization

Now, we can formally define the **generalized Schur complement of the block $$A$$ of the matrix $$M$$** as the $$m \times m$$ matrix

$$ M/A = D - C A^\dagger B. $$

The **generalized Schur complement of the block $$D$$ of the matrix $$M$$** is defined as the $$n \times n$$ matrix

$$ M/D = A - B D^\dagger C. $$

**Lemma (Factorization using Generalized Schur complements)**: If $$(I - A A^\dagger) B = \zero$$ and $$(I - A^* A^\dagger) C^* = \zero$$, then

$$
    M = \begin{bmatrix} I & \zero \\ C A^\dagger & I \end{bmatrix}
        \begin{bmatrix} A & \zero \\ \zero & M/A \end{bmatrix}
        \begin{bmatrix} I & A^\dagger B \\ \zero & I \end{bmatrix}.
$$

If $$(I - D^* D^\dagger) B^* = \zero$$ and $$(I - D D^\dagger) C = \zero$$, then

$$
    M = \begin{bmatrix} I & B D^\dagger \\ \zero & I \end{bmatrix}
        \begin{bmatrix} M/D & \zero \\ \zero & D \end{bmatrix}
        \begin{bmatrix} I & \zero \\ D^\dagger C & I \end{bmatrix}.
$$

These identities can be checked by straightforward matrix multiplication, using the properties of the pseudoinverse, and observing that for any $$P \in \F^{n \times n}$$ and $$N \in \F^{n \times m}$$,

$$
    (I - P P^\dagger) N = \zero
    \ \iff \ N = P P^\dagger N
    \ \iff \ N^* = N^* P^\dagger P^*.
$$


### Characterizing Symmetric Positive Semidefinite Matrices

This section again considers the special case where $$M$$ is real and symmetric (i.e., $$C = B^\top$$).

**Lemma (Minimization of a Convex Quadratic Function):** For all $$P \in \Sym^n$$, the function $$f: \R^n \to \R$$

$$ f(x) =  x^\top P x + 2 x^\top b$$

has a minimum value if and only if $$P \succeq 0$$ and $$(I - P P^\dagger) b = \zero$$ (or equivalently, $$b \in \range P$$), in which case the minimum value is

$$ p_* = -b^\top P^\dagger b. $$

Furthermore, if $$r = \rank P$$ and $$P = Q D Q^\top$$ is an eigendecomposition (equivalently, a full SVD) of $$P$$, then the optimal value is achieved by all $$x_* \in \R^n$$ of the following form for all $$z \in \R^{n-r}$$:

$$ x_* = -P^\dagger b + Q \begin{bmatrix} \zero_r \\ z \end{bmatrix}. $$

<details markdown="block"><summary>Proof</summary>

*Note: This proof is rather lengthy. For a warm-up, consider first reading through the proof of the next lemma, which uses many of the same ideas but with less notation.*

Observe that

$$
    (x + P^\dagger b)^\top P (x + P^\dagger b)
    = x^\top P x + 2 x^\top P P^\dagger b + b^\top P^\dagger b.
$$

Therefore,

$$
\begin{aligned}
    f(x)
    &= (x + P^\dagger b)^\top P (x + P^\dagger b) - 2 x^\top P P^\dagger b - b^\top P^\dagger b + 2 x^\top b \\
    &= (x + P^\dagger b)^\top P (x + P^\dagger b) + 2 x^\top (I - P P^\dagger) b - b^\top P^\dagger b.
\end{aligned}
$$

First, we show that if $$f$$ has a minimum value, then both $$P \succeq 0$$ and $$(I - P P^\dagger) b = \zero$$. By contrapositive, suppose that $$(I - P P^\dagger) b \neq \zero$$ and that $$P \not\succeq 0$$, so $$P$$ has a negative eigenvalue $$\lambda < 0$$. Let $$v \neq \zero$$ be a corresponding eigenvector, so $$Pv = \lambda v$$. For any $$a \in \R$$, if we let $$x = av - P^\dagger b$$, then

$$
\begin{aligned}
    f(x)
    &= av^\top P av + 2 (av - P^\dagger b)^\top (I - P P^\dagger) b - b^\top P^\dagger b \\
    &= a^2 \lambda \norm{v}_2^2 + 2a v^\top (I - P P^\dagger) b - 2 b^\top \underbrace{P^\dagger (I - P P^\dagger)}_{=\zero} b - b^\top P^\dagger b \\
    &= a^2 \lambda \norm{v}_2^2 + 2a v^\top (I - P P^\dagger) b - b^\top P^\dagger b \\
\end{aligned}
$$

Since $$\lambda < 0$$ and $$\norm{v}_2 > 0$$, this is a parabola in $$a$$ with a negative leading coefficient. As $$a$$ can be made arbitrarily large, $$f$$ is evidently unbounded below. Therefore, at least one of $$P \succeq 0$$ or $$(I - P P^\dagger) b = \zero$$ must be true.

Now, suppose $$(I - P P^\dagger) b = \zero$$, but $$P$$ has a negative eigenvalue. Then, the expression above remains a concave parabola in $$a$$, so $$f$$ is still unbounded below. Therefore, if $$f$$ has a minimum value and $$(I - P P^\dagger) b = \zero$$, then $$P$$ must only have nonnegative eigenvalues, i.e., $$P \succeq 0$$.

Instead, suppose that $$P \succeq 0$$, but $$(I - P P^\dagger) b \neq \zero$$, so $$b \neq \zero$$. Let $$r = \rank P < n$$. (If $$\rank P = n$$, then $$P$$ would be invertible and $$I - P P^\dagger = \zero$$ which contradicts the assumption.) By the Real Spectral Theorem (LADR 7.29), there exists an orthonormal basis $$v_1, \dotsc, v_n$$ consisting of eigenvectors of $$P$$. Let $$v_1, \dotsc, v_r$$ correspond to positive eigenvalues, and let $$v_{r+1}, \dotsc, v_n$$ correspond to the 0 eigenvalue. Note that

$$
\begin{aligned}
    \range P &= \spanset{v_1, \dotsc, v_r} \\
    \null P &= \spanset{v_{r+1}, \dotsc, v_n}
\end{aligned}
$$

and every element in $$\null P$$ is an eigenvector of $$P$$ with eigenvalue 0. Since $$b \not\in \range P$$ (by a previous lemma) and $$v_1, \dotsc, v_n$$ is a basis of $$\R^n$$, this means $$b \in \spanset{v_{r+1}, \dotsc, v_n} = \null P$$. Therefore, $$b$$ is an eigenvector of $$P$$ corresponding to eigenvalue 0. For every $$v \in \null P$$,

$$
\begin{aligned}
    v^\top (I - P P^\dagger) b
    &= v^\top b - v^\top P P^\dagger b \\
    &= v^\top b - b^\top P^\dagger Pv \\
    &= v^\top b.
\end{aligned}
$$

In particular, choosing $$x = ab - P^\dagger b$$ yields $$f(x) = 2a \norm{b}_2^2 - b^\top P^\dagger b$$ which is unbounded below as $$a \to -\infty$$.

> Note: Using results from convexity can dramatically simplify the proof that if $$P \succeq 0$$, then $$f$$ has a minimum if and only if $$(I - P P^\dagger) b = \zero$$. If $$P \succeq 0$$, then $$f$$ is a convex function. The first order optimality condition states that $$f$$ attains a minimum at $$x_*$$ if and only if
>
> $$ \nabla_x f(x_*) = 2 P x_* + 2b = \zero.$$
>
> However, if $$(I - P P^\dagger) b \neq \zero$$, then by the previous lemma, $$b \not\in \range P$$, and it would be impossible for the equality above to hold.

We have thus shown

$$
\begin{aligned}
    &f \text{ has a minimum value} \\
    &\implies P \succeq 0 \text{ or } (I - P P^\dagger) b = \zero \\
    &\implies P \succeq 0 \text{ and } (I - P P^\dagger) b = \zero.
\end{aligned}
$$

The converse is simpler. If both $$P \succeq 0$$ and $$(I - P P^\dagger) b = \zero$$, then

$$ f(x) = (x + P^\dagger b)^\top P (x + P^\dagger b) - b^\top P^\dagger b. $$

Since $$(x + P^\dagger b)^\top P (x + P^\dagger b) \geq 0$$ for all $$x$$, it is minimized with value 0 when $$P (x + P^\dagger b) = \zero$$. In other words, $$f$$ is minimized with value $$p_* = -b^\top P^\dagger b$$.

We have shown that $$f$$ has a minimum value if and only if $$P \succeq 0$$ and $$(I - P P^\dagger) b = \zero$$. Furthermore, the minimum is achieved by any $$x_*$$ such that $$x_* + P^\dagger b \in \null P$$. For all $$x_*$$ of the form $$x_* = -P^\dagger b + Q \begin{bmatrix} \zero_r \\ z \end{bmatrix}$$,
 we have

$$
\begin{aligned}
    P (x_* + P^\dagger b)
    &= P Q \begin{bmatrix} \zero_r \\ z \end{bmatrix}
    = Q D Q^\top Q \begin{bmatrix} \zero_r \\ z \end{bmatrix} \\
    &= Q D \begin{bmatrix} \zero_r \\ z \end{bmatrix}
    = \zero
\end{aligned}
$$

since $$Q^\top Q = I$$ and $$D = \diag(\sigma_1, \dotsc, \sigma_r, 0_{r+1}, \dots, 0_n)$$. Therefore, $$x_* + P^\dagger b \in \null P$$, so $$f$$ is minimized by all $$x_*$$ of the form above.

*Source*: This lemma is stated as Proposition 15.2 in Gallier's *Geometric Methods and Applications* and as Proposition 4.2 in Gallier's "The Schur Complement" ([References](#references)), but the proof is different. I find my proof more intuitive and direct than Gallier's. I avoid having to first prove the following corollary, and I also avoid the clunky notation of block matrices and vectors.

</details>


**Corollary (Minimization of a Strictly Convex Quadratic Function):** If $$P \in \Sym^n$$ is invertible, then

$$ f(x) =  x^\top P x + 2 x^\top b$$

has a minimum value if and only if $$P \succ 0$$, in which case the minimum value is uniquely attained by $$x_* = -P^{-1} b$$ with $$f(x_*) = -b^\top P^{-1} b$$.

<details markdown="block"><summary>Proof</summary>

Because $$P$$ is now invertible, $$P^{-1} = P^\dagger$$. Making this substitution in the previous lemma yields the corollary. Now $$\rank P = n$$, so $$x_* = -P^{-1} b + Q \zero_n = -P^{-1} b$$ is unique. Furthermore, ($$P$$ is invertible and $$P \succeq 0$$) $$\iff P \succ 0$$.

Below, we give a complete proof separate from the previous lemma. Note that

$$
    (x + P^{-1} b)^\top P (x + P^{-1} b)
    = x^\top P x + 2 x^\top b + b^\top P^{-1} b.
$$

Thus,

$$ f(x) = (x + P^{-1} b)^\top P (x + P^{-1} b) - b^\top P^{-1} b. $$

First, we show that if $$f$$ has a minimum value, then we must have $$P \succ 0$$. By contrapositive, suppose that $$P$$ has a negative eigenvalue $$\lambda < 0$$ with a corresponding eigenvector $$v$$, so $$Pv = \lambda v$$. For any $$\alpha \in \R$$, if we let $$x = \alpha v - P^{-1} b$$, then

$$
\begin{aligned}
    f(x)
    &= (x + P^{-1} b)^\top P (x + P^{-1} b) - b^\top P^{-1} b \\
    &= \alpha v^\top P \alpha v - b^\top P^{-1} b \\
    &= \alpha^2 \lambda \norm{v}_2^2 - b^\top P^{-1} b.
\end{aligned}
$$

Since $$\lambda < 0$$ and $$\alpha$$ can be made arbitrarily large, evidently $$f$$ is unbounded below. Therefore, if $$f$$ has a minimum, then $$P$$ must only have nonnegative eigenvalues. Furthermore, since $$P$$ is invertible, it has no zero eigenvalues. Thus, $$P \succ 0$$.

Now, suppose $$P \succ 0$$. Then $$(x + P^{-1} b)^\top P (x + P^{-1} b) \geq 0$$ for all $$x$$, and it is minimized with value 0 when $$x + P^{-1} b = \zero$$. In other words, $$f(x)$$ is minimized by $$x_* = -P^{-1} b$$, with value $$f(x_*) = -b^\top P^{-1} b$$.

*Source*: This lemma is stated as Proposition 15.1 in Gallier's *Geometric Methods and Applications* and as Proposition 4.1 in Gallier's "The Schur Complement" ([References](#references)). The direct proof (not as a corollary) is largely borrowed from Gallier.

</details>


**Theorem (Conditions for Positive Semi-Definiteness):** For any symmetric matrix $$M = \begin{bmatrix} A & B \\ B^\top & D \end{bmatrix}$$, the following conditions are equivalent:

1. $$M \succeq 0$$.
2. $$A \succeq 0$$, $$(I_n - A A^\dagger) B = \zero_{n \times m}$$, $$D - B^\top A^\dagger B \succeq 0$$.
3. $$D \succeq 0$$, $$(I_m - D D^\dagger) B^\top = \zero_{m \times n}$$, $$A - B D^\dagger B^\top \succeq 0$$.

<details markdown="block"><summary>Proof</summary>

Recall the function $$f: \R^n \times \R^m \to \R$$ defined in the previous section as

$$
    f(x,y)
    = [x^\top \ y^\top]
       M
       \begin{bmatrix} x \\ y \end{bmatrix}
    = x^\top A x + 2 x^\top B y + y^\top D y.
$$

By definition, $$M \succeq 0$$ if and only if $$f(x,y) \geq 0$$ for all $$(x,y) \in \R^n \times \R^m$$. Thus, we seek to characterize when $$f(x,y)$$ is bounded below.

Holding $$y$$ constant, the previous lemma implies that $$f(x,y)$$ has a minimum if and only if $$A \succeq 0$$ and $$(I - A A^\dagger) By = \zero$$, with minimum value

$$
    f(x_*,y)
    = -y^\top B A^\dagger B y + y^\top D y
    = y^\top (D - B^\top A^\dagger B) y.
$$

Since $$f$$ must be bounded below for all $$y$$, we must have $$(I - A A^\dagger) B = \zero$$. Again applying the previous lemma, $$f(x_*,y)$$ has a minimum over $$y$$ if and only if $$D - B^\top A^\dagger B \succeq 0$$, so $$f(x_*,y) \geq 0$$ for all $$y$$. Therefore, $$f(x,y)$$ has a minimum over all $$x,y$$ if and only if

$$
    A \succeq 0, \
    (I - A A^\dagger) B = \zero, \text{ and }
    D - B^\top A^\dagger B \succeq 0,
$$

with minimum value $$f(x_*, y_*) = 0$$. Similarly, if we instead hold $$x$$ constant, then $$f(x,y)$$ has a minimum if and only if $$D \succeq 0$$ and $$(I - D D^\dagger) B^\top x = \zero$$, with minimum value

$$
    f(x,y_*)
    = -x^\top B D^\dagger B^\top x + x^\top A x
    = x^\top (A - B D^\dagger B^\top) x.
$$

Since $$f$$ must be bounded below for all $$x$$, we must have $$(I - D D^\dagger) B^\top = \zero$$. Furthermore, $$f(x,y_*)$$ has a minimum over $$x$$ if and only if $$A - B D^\dagger B^\top \succeq 0$$. Therefore, $$f(x,y)$$ has a minimum over all $$x,y$$ if and only if

$$
    D \succeq 0, \
    (I - D D^\dagger) B^\top = \zero, \text{ and }
    A - B D^\dagger B^\top \succeq 0.
$$

*Source*: Theorem 16.1 in Gallier's *Geometric Methods and Applications* and Theorem 4.3 in Gallier's "The Schur Complement" ([References](#references)).

</details>

If $$M \succeq 0$$, then it has the following factorizations:

$$
\begin{aligned}
    M
    &= \begin{bmatrix} I & \zero \\ B^\top A^\dagger & I \end{bmatrix}
       \begin{bmatrix} A & \zero \\ \zero & D - B^\top A^\dagger B \end{bmatrix}
       \begin{bmatrix} I & A^\dagger B \\ \zero & I \end{bmatrix} \\
    &= \begin{bmatrix} I & B D^\dagger \\ \zero & I \end{bmatrix}
       \begin{bmatrix} A - B D^\dagger B^\top & \zero \\ \zero & D \end{bmatrix}
       \begin{bmatrix} I & \zero \\ D^\dagger B^\top & I \end{bmatrix}.
\end{aligned}
$$


## References

* Jean Gallier. *Geometric Methods and Applications, 2e,* 2011. [https://doi.org/10.1007/978-1-4419-9961-0](https://doi.org/10.1007/978-1-4419-9961-0).
  - Gallier's textbook covers most of the material from this post, including the generalized Schur complement using pseudoinverses. CH 16.1 proves the matrix inversion lemma (without using determinants), CH 16.2 considers Schur complements in symmetric matrices, and CH 16.3 considers generalized Schur complements in symmetric matrices.
  - CH 15.1 and 15.2 provide the lemmas used for the generalized Schur complements.

* Jean Gallier. "The Schur Complement and Symmetric Positive Semidefinite (and Definite) Matrices," 2019. [https://www.cis.upenn.edu/~jean/schur-comp.pdf](https://www.cis.upenn.edu/~jean/schur-comp.pdf).
  - Gallier's notes mostly mirror his textbook (Section 1 = CH 16.1, Section 2 = CH 16.2, Section 4 = CH 15.1/15.2/16.3), combining the relevant chapters into a succinct exposition on Schur Complements. While my post borrows many results from Gallier, I provided new or more detailed proofs in several places, most notably the lemma on Minimization of a Convex Quadratic Function.

* S. Boyd and L. Vandenberghe. *Convex Optimization*, 2004. [https://web.stanford.edu/~boyd/cvxbook/](https://web.stanford.edu/~boyd/cvxbook/).
  - Appendix A.5.5 discusses Schur complements when $$M$$ is symmetric, including a derivation of $$M^{-1}$$ as well as the conditions for positive definiteness and semidefiniteness.
  - Appendix C.4.1 essentially derives the form of $$M^{-1}$$ when $$A$$ and $$M/A$$ are invertible.
  - Appendix C.4.3 derives the simpler form of the Woodbury matrix identity.

* C.E. Rasmussen and C.K.I. Williams. *Gaussian Processes for Machine Learning*, 2006. [http://www.gaussianprocess.org/gpml/](http://www.gaussianprocess.org/gpml/).
  - Appendix A.3 describes the Woodbury matrix identity and the matrix inversion lemma, without proof.

* T. Lienart. "Matrix inversion lemmas." [https://tlienart.github.io/pub/csml/mtheory/matinvlem.html](https://tlienart.github.io/pub/csml/mtheory/matinvlem.html).
  - As of May 9, 2021, Lienart's notes provides a concise derivation of the matrix inversion lemma, albeit with some [additional unwritten assumptions](https://github.com/tlienart/tlienart.github.io/issues/38).
  - Shows the relation between the matrix inversion lemma and the Sherman-Morrison formula.

* Relevant Wikipedia pages:
  - [Schur_complement](https://en.wikipedia.org/wiki/Schur_complement): defines the Schur complement and gives conditions for positive (semi-)definiteness in symmetric matrices, but misses details on the matrix inversion lemma.
  - [Invertible matrix: Blockwise inversion](https://en.wikipedia.org/wiki/Invertible_matrix#Blockwise_inversion): shows the correspondence between the two inverses of $$M$$ used in the matrix inversion lemma, but misses proof details.
  - [Woodbury matrix identity](https://en.wikipedia.org/wiki/Woodbury_matrix_identity): gives a direct proof of the Woodbury matrix identity without discussing Schur complements.

* S. Axler. *Linear Algebra Done Right, 3e*, 2015. [https://linear.axler.net/](https://linear.axler.net/).
  - General linear algebra reference, abbreviated as LADR in this post.

* Another interesting matrix inversion lemma which considers $$M^\top M$$ is provided on StackExchange [here](https://math.stackexchange.com/a/412136), although I haven't taken the time to verify it completely.