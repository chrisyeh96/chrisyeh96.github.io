---
title: Schur Complements and the Matrix Inversion Lemma
layout: post
use_math: true
use_toc: true
last_updated: 2021-05-19
tags: [math]
excerpt: I prove key properties of Schur Complements and use them to derive the matrix inversion lemma.
---

$$
\newcommand{\C}{\mathbb{C}}  % complex numbers
\newcommand{\zero}{\mathbf{0}}  % zeros vector
\DeclareMathOperator{\det}{det}  % determinant
$$

## Preliminaries

The post assumes standard linear algebra knowledge at the level presented in S. Axler's *Linear Algebra Done Right, 3e* (LADR). All results in this post apply to both real and complex-valued matrices, unless otherwise specified. Finally, $$I_n$$ denotes the $$n \times n$$ identity matrix.


## Summary

I summarize the key results here. Consider a square matrix with block partition

$$
    M = \begin{bmatrix} A & B \\ C & D \end{bmatrix}.
$$

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

Finally, the positive (semi-)definiteness of $$M$$ is related to the positive (semi-)definiteness of its Schur complements. The following three statements are equivalent:

* $$M \succ 0$$;
* $$A \succ 0$$ and $$(M/A) \succ 0$$;
* $$D \succ 0$$ and $$(M/D) \succ 0$$.


## Schur Complements

### Definition

Consider a square matrix $$M$$ of size $$(n+m) \times (n+m)$$, partitioned as

$$
    M = \begin{bmatrix} A & B \\ C & D \end{bmatrix}
$$

where $$A \in \C^{n \times n}$$, $$B \in \C^{n \times m}$$, $$C \in \C^{m \times n}$$, and $$D \in \C^{m \times m}$$.

If $$A$$ is invertible, the **Schur complement of the block $$A$$ of the matrix $$M$$** is defined as the $$m \times m$$ matrix

$$
    M/A = D - C A^{-1} B.
$$

Similarly, if $$D$$ is invertible, the **Schur complement of the block $$D$$ of the matrix $$M$$** is defined as the $$n \times n$$ matrix

$$
    M/D = A - B D^{-1} C.
$$


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

*Proof*: Both of the equalities can be seen by directly multiplying the matrix factors.


**Lemma (Determinant of Block Matrix)**: If $$A$$ is invertible, then $$\det(M) = \det(A) \det(M/A)$$. Similarly, if $$D$$ is invertible, then $$\det(M) = \det(D) \det(M/D)$$.

<details markdown="block"><summary>Proof</summary>

The proof is a direct application of three properties of determinants to the factorization of $$M$$ given in the previous lemma.
* The determinant of the product of two matrices is the product of their determinants: $$\det(AB) = \det(A) \det(B)$$. (Theorem 10.40 in LADR)
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

A matrix is invertible if and only if its determinant is nonzero (Theorems 10.24 and 10.42 in LADR). Combining this fact with the previous lemma yields the desired result.

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
    M \begin{bmatrix} x \\ y \end{bmatrix} = \begin{bmatrix} a \\ b \end{bmatrix}.
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


## Matrix Inversion Lemma

The matrix inversion lemma is a corollary of the previous theorem.

**Matrix Inversion Lemma**: If $$A$$ and $$D$$ are invertible, and any of ($$M$$, $$M/A$$, or $$M/D$$) are invertible, then all of the following statements hold:
* all of $$M$$, $$M/A$$, and $$M/D$$ are invertible;
* $$(M/A)^{-1} = D^{-1} + D^{-1} C (M/D)^{-1} B D^{-1}$$;
* $$(M/D)^{-1} = A^{-1} + A^{-1} B (M/A)^{-1} C A^{-1}$$.

<details markdown="block"><summary>Proof</summary>

The 1st statement is a clear consequence of the previous theorem.

To see the 2nd and 3rd statements, note that the previous theorem provides two different expressions for the inverse of $$M$$. Since a matrix inverse is unique, equating the two expressions yields the desired result. In fact, since the previous theorem provides 2 valid ways to write out each block of $$M^{-1}$$, this provides $$2^4 = 16$$ valid expressions for $$M^{-1}$$.

</details>

Note that the 2nd and 3rd statements in the matrix inversion lemma do not actually require constructing the full block matrix $$M$$. Thus, the lemma is often stated without explicitly constructing $$M$$, and instead directly considers arbitrary matrices $$A \in \C^{n \times n}$$, $$B \in \C^{n \times m}$$, $$C \in \C^{m \times n}$$, and $$D \in \C^{m \times m}$$.

**Matrix Inversion Lemma (alternate form)**: For any invertible matrices $$A$$ and $$D$$ and any matrices $$B$$ and $$C$$, if either $$(D - C A^{-1} B)$$ or $$(A - B D^{-1} C)$$ is invertible, then both are invertible and are related by the identities

$$
    \begin{aligned}
    (D - C A^{-1} B)^{-1} &= D^{-1} + D^{-1} C (A - B D^{-1} C)^{-1} B D^{-1} \\
    (A - B D^{-1} C)^{-1} &= A^{-1} + A^{-1} B (D - C A^{-1} B)^{-1} C A^{-1}.
    \end{aligned}
$$

If we substitute $$\bar{C} = -C$$ and $$\bar{D} = D^{-1}$$ into the matrix inversion lemma, then we arrive at the Woodbury matrix identity.

**Woodbury matrix identity**: For any invertible matrices $$A$$ and $$\bar{D}$$ and any matrices $$B$$ and $$\bar{C}$$, if either $$(A + B \bar{D} \bar{C})$$ or $$(\bar{D}^{-1} + \bar{C} A^{-1} B)$$ is invertible, then both are invertible and are related by

$$
    (A + B \bar{D} \bar{C})^{-1} = A^{-1} - A^{-1} B (\bar{D}^{-1} + \bar{C} A^{-1} B)^{-1} \bar{C} A^{-1}.
$$

Some texts such as Boyd's *Convex Optimization* book (Appendix C.4.3) substitute $$D = -I_m$$ (which is invertible) into the matrix inversion lemma.

**Woodbury matrix identity (simpler form)**: For any invertible matrix $$A$$, if either $$(I + C A^{-1} B)$$ or $$(A + BC)^{-1}$$ is invertible, then both are invertible and are related by

$$
    (A + BC)^{-1} = A^{-1} - A^{-1} B (I + C A^{-1} B)^{-1} C A^{-1}.
$$

Finally, the special case of the matrix inversion lemma where $$A \in \R^{n \times n}$$, $$B = u \in \R^n$$, $$C = v^T \in \R^{1 \times n}$$, and $$D = D^{-1} = -1$$ is known as the Sherman-Morrison formula:

**Sherman-Morrison formula**: For any invertible matrix $$A \in \R^{n \times n}$$ and vectors $$u, v \in \R^n$$, then

$$ (A + uv^T) \text{ is invertible} \ \iff \ 1 + v^T A^{-1} u \neq 0 $$

and if either holds, then

$$
    (A + uv^T)^{-1} = A^{-1} - \frac{A^{-1} u v^T A^{-1}}{1 + v^T A^{-1} u}.
$$

**Discussion**

The matrix inversion lemma naturally leads to the following question: if $$A$$ and $$D$$ are invertible, do we actually need the condition that one of ($$M$$, $$M/A$$, or $$M/D$$) is invertible in order for the lemma to hold? The answer is yes, as shown by the following counterexample.

Consider the all-ones matrix $$M = \begin{bmatrix} 1 & 1 \\ 1 & 1 \end{bmatrix}.$$ Clearly $$A = D = 1$$ is invertible, but $$M$$ is not invertible because it is not full-rank.

On the other hand, there also exist invertible matrices where neither $$A$$ nor $$D$$ are invertible, such as

$$
    M = \begin{bmatrix} 0 & 1 \\ 1 & 0 \end{bmatrix}
$$

whose inverse is itself. In other words, the matrix inversion lemma may be useful in many settings, but it does not apply to all invertible matrices.


## Schur Complements for Symmetric Matrices

This section considers the special case where $$M$$ is real and symmetric (i.e., $$C = B^T$$):

$$ M = \begin{bmatrix} A & B \\ B^T & D \end{bmatrix}. $$

The following function $$f: \R^n \times \R^m \to \R$$ is useful for our analysis of $$M$$:

$$
    \begin{aligned}
    f(u,v)
    &= \begin{bmatrix} u^T & v^T \end{bmatrix}
       M
       \begin{bmatrix} u \\ v \end{bmatrix} \\
    &= u^T A u + 2 u^T B v + v^T D v
    \\
    \nabla f(u,v) &= 2 M \begin{bmatrix} u \\ v \end{bmatrix}
    \\
    \nabla^2 f(u,v) &= 2M.
    \end{aligned}
$$

Note that this implies

$$
    \begin{aligned}
    \nabla_u f(u,v) &= 2Au + 2Bv      &  \nabla^2_u f(u,v) &= 2A \\
    \nabla_v f(u,v) &= 2Dv + 2 B^T u  &  \nabla^2_v f(u,v) &= 2D
    \end{aligned}
$$

**Lemma (Positive definite diagonal blocks)**: If $$M \succ 0$$, then $$A, D \succ 0$$. If $$M \succeq 0$$, then $$A, D \succeq 0$$.

<details markdown="block"><summary>Proof</summary>

Suppose $$M \succ 0$$, so by definition $$\forall (u,v) \neq \zero: \ f(u,v) > 0$$.

First, consider $$v = \zero$$. Then $$f(u, v=\zero) = u^T A u > 0$$ for all $$u \neq \zero$$. This shows $$A \succ 0$$.

Likewise, consider $$u = \zero$$. Then $$f(u=\zero, v) = v^T D v > 0$$ for all $$v \neq \zero$$. This shows $$D \succ 0$$.

The proof for the semidefinite case is nearly identical, where $$>$$ is replaced with $$\geq$$.

</details>


**Theorem (Conditions for Positive Definiteness):** The following three conditions are equivalent:
1. $$M \succ 0$$,
2. $$A \succ 0$$ and $$(M/A) \succ 0$$,
3. $$D \succ 0$$ and $$(M/D) \succ 0$$.

<details markdown="block"><summary>Proof</summary>

*Note*: This proof assumes knowledge about convex functions. See, e.g., *Convex Optimization* by Boyd, listed in [References](#references). For a proof that does not require knowledge of convexity, see Propositions 2.1 and 2.2 by Gallier, again listed in [References](#references).

First, we show (1) $$\implies$$ (2) and (3). Suppose $$M \succ 0$$, so $$A, D \succ 0$$ by the previous lemma. Since $$\nabla^2 f(u,v) = 2M \succ 0$$, $$f$$ is convex in both $$u$$ and $$v$$. For fixed $$v$$, $$f$$ is minimized by the value $$u^*$$ such that

$$ \nabla_u f(u^*, v) = 2Au^* + 2Bv = 0 $$

so $$u^* = -A^{-1} Bv$$. Similarly, $$v^* = -D^{-1} B^T u$$ minimizes $$f$$ for fixed $$u$$.

Plugging these values back into $$f$$ gives

$$
    \begin{aligned}
    f(u^*, v)
    &= (A^{-1} Bv)^T Bv - 2 (A^{-1} Bv)^T Bv + v^T D v \\
    &= v^T (D - B^T A^{-1} B) v \\
    &= v^T (M/A) v
    \\
    f(u, v^*)
    &= u^T A u - 2 u^T B D^{-1} B^T u + u^T B D^{-1} B^T u \\
    &= u^T (A - B D^{-1} B^T) u \\
    &= u^T (M/D) u
    \end{aligned}
$$

Since $$M \succ 0$$, by definition $$\forall (u,v) \neq \zero: \ f(u,v) > 0$$. This requires $$v^T (M/A) v > 0$$ and $$u^T (M/D) u > 0$$ for all $$u,v \neq \zero$$, which implies $$(M/A), (M/D) \succ 0$$.

Now we show that (2) $$\implies$$ (1). Suppose $$A, (M/A) \succ 0$$ and consider any $$(u,v) \neq \zero$$. If $$v = \zero$$ so $$u \neq \zero$$, then $$f(u,v) = u^T A u > 0$$. If $$v \neq \zero$$, then $$f(u,v) \geq f(u^*, v) = v^T (M/A) v > 0$$. Thus, $$\forall (u,v) \neq \zero: \ f(u,v) > 0$$, so $$M \succ 0$$ by definition.

A similar argument shows that (3) $$\implies$$ (1).

</details>

**Theorem (Conditions for Positive Semidefiniteness)**: If $$A \succ 0$$, then

$$ M \succeq 0 \ \iff \ (M/A) \succeq 0. $$

Similarly, if $$D \succ 0$$, then

$$ M \succeq 0 \ \iff \ (M/D) \succeq 0. $$

<details markdown="block"><summary>Proof</summary>

*Note*: This proof assumes knowledge about convex functions. See, e.g., *Convex Optimization* by Boyd, listed in [References](#references). For a proof that does not require knowledge of convexity, see Propositions 2.1 and 2.2 by Gallier, again listed in [References](#references).

Suppose $$A \succ 0$$ and $$M \succeq 0$$, so $$\forall (u,v) \neq \zero:\ f(u,v) \geq 0$$. For any $$v \neq \zero$$, the proof for the previous theorem shows that

$$
    f(u^*, v) = v^T (M/A) v \geq 0,
$$

so $$(M/A) \succeq 0$$ by definition.

Now suppose $$A \succ 0$$ and $$(M/A) \succeq 0$$, and consider any $$(u,v) \neq \zero$$. If $$v = \zero$$ so $$u \neq \zero$$, then $$f(u,v) = u^T A u > 0$$. If $$v \neq \zero$$, then $$f(u,v) \geq f(u^*, v) = v^T (M/A) v \geq 0$$. Thus, $$\forall (u,v) \neq \zero: \ f(u,v) \geq 0$$, so $$M \succeq 0$$ by definition.

A similar argument proves the result for the case $$D \succ 0$$.

</details>


## References

* Jean Gallier. "The Schur Complement and Symmetric Positive Semidefinite (and Definite) Matrices," 2019. [https://www.cis.upenn.edu/~jean/schur-comp.pdf](https://www.cis.upenn.edu/~jean/schur-comp.pdf).
  - Gallier's notes cover most of the material from this post, including additional extensions to psuedoinverses. Section 1 proves the matrix inversion lemma (without using determinants), while Section 2 considers Schur complements in symmetric matrices.

* S. Boyd and L. Vandenberghe. *Convex Optimization*, 2004. [https://web.stanford.edu/~boyd/cvxbook/](https://web.stanford.edu/~boyd/cvxbook/).
  - Appendix A.5.5 discusses Schur complements when $$M$$ is symmetric, including a derivation of $$M^{-1}$$ as well as the conditions for positive definiteness and semidefiniteness.
  - Appendix C.4.1 essentially derives the form of $$M^{-1}$$ when $$A$$ and $$M/A$$ are invertible
  - Appendix C.4.3 derives the simpler form of the Woodbury matrix identity.

* C.E. Rasmussen and C.K.I. Williams. *Gaussian Processes for Machine Learning*, 2006. [http://www.gaussianprocess.org/gpml/](http://www.gaussianprocess.org/gpml/).
  - Appendix A.3 describes the Woodbury matrix identity and the matrix inversion lemma, without proof.

* T. Lienart. "Matrix inversion lemmas." [https://tlienart.github.io/pub/csml/mtheory/matinvlem.html](https://tlienart.github.io/pub/csml/mtheory/matinvlem.html).
  - As of May 9, 2021, provides a concise derivation of the matrix inversion lemma, albeit with some [additional unwritten assumptions](https://github.com/tlienart/tlienart.github.io/issues/38).
  - Shows the relation between the matrix inversion lemma and the Sherman-Morrison formula.

* Relevant Wikipedia pages:
  - [Schur_complement](https://en.wikipedia.org/wiki/Schur_complement): defines the Schur complement and gives conditions for positive (semi-)definiteness in symmetric matrices, but misses details on the matrix inversion lemma.
  - [Invertible matrix: Blockwise inversion](https://en.wikipedia.org/wiki/Invertible_matrix#Blockwise_inversion): shows the correspondence between the two inverses of $$M$$ used in the matrix inversion lemma, but misses proof details.
  - [Woodbury matrix identity](https://en.wikipedia.org/wiki/Woodbury_matrix_identity): gives a direct proof of the Woodbury matrix identity without discussing Schur complements.

* S. Axler. *Linear Algebra Done Right, 3e*, 2015. [https://linear.axler.net/](https://linear.axler.net/).
  - General linear algebra reference, abbreviated as LADR in this post.

* Another interesting matrix inversion lemma which considers $$M^T M$$ is provided on StackExchange [here](https://math.stackexchange.com/a/412136), although I haven't taken the time to verify it completely.