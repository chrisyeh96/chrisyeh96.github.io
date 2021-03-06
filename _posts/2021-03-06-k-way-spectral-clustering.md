---
title: An Overview of k-way Spectral Clustering
layout: post
use_math: true
use_toc: true
last_updated: 2021-03-06
tags: [ML]
excerpt: Given an undirected graph $$G = (V, E)$$, a common task is to identify clusters among the nodes. It is a well-known fact that the sign of entries in the second eigenvector of the normalized Graph Laplacian matrix provides a convenient way to partition the graph into two clusters; this "spectral clustering" method has strong theoretical foundations. In this post, I highlight several theoretical works that generalize the technique for $$k$$-way clustering.
---

$$
\newcommand{\N}{\mathbb{N}}  % natural numbers
\newcommand{\R}{\mathbb{R}}  % real numbers
\newcommand{\abs}[1]{\left\lvert#1\right\rvert}  % absolute value
\newcommand{\inner}[2]{\left\langle#1,\ #2\right\rangle}  % inner product
\newcommand{\norm}[1]{\left\|#1\right\|}  % norm
\newcommand{\one}{\mathbf{1}}  % ones vector
\newcommand{\zero}{\mathbf{0}}  % ones vector
\DeclareMathOperator*{\argmax}{arg\,max}
\DeclareMathOperator*{\argmin}{arg\,min}
\DeclareMathOperator{\diag}{diag}  % diagonal
$$

## Preliminaries and Notation

Let $$G = (V, E)$$ be an undirected graph with $$\abs{V} = n$$ nodes. Let the nodes be numbered $$V = \{1, \dotsc, n\}$$, and let $$d_i$$ denote the degree of node $$i$$ (i.e., the number of edges adjacent to node $$i$$).

Let $$\zero$$ denote a vector of all zeros, and let $$\one$$ denote a vector of all ones.

We call $$\{S_i\}_{i=1}^k$$ a $$k$$-partition of $$V$$ if the $$S_i \subseteq V$$ are disjoint, and $$V = S_1 \cup \dotsb \cup S_k$$.

For any subset of nodes $$S \subseteq V$$, let $$\bar{S}$$ denote its complement, and define the following quantities:

- edge set: $$E(S, \bar{S}) = \{\{i,j\} \in E \mid i \in S,\ j \in \bar{S} \}$$
- volume: $$d(S) = \sum_{i \in S} d_i$$, also known as the association of $$S$$ with $$V$$
- expansion: $$\phi(S) = \frac{\abs{E(S, \bar{S})}}{\min(d(S), d(\bar{S}))}$$
- normalized cut: $$N_{cut}(S) = \frac{\abs{E(S, \bar{S})}}{d(S)} + \frac{\abs{E(\bar{S}, S)}}{d(\bar{S})}$$

By convention, we define $$\phi(S) = N_{cut}(S) = \infty$$ for $$S = \emptyset$$ and $$S = V$$.

Intuitively, a cluster should have small expansion and normalized cut. For example, if $$G$$ is disconnected, let $$S$$ be one of the connected components. Then $$\abs{E(S, \bar{S})} = 0$$, so $$\phi(S) = N_{cut}(S) = 0$$. On the other hand, if $$G$$ is fully-connected, then for any $$S \subset V$$ with $$S \neq \emptyset$$,

$$
\begin{aligned}
    \phi(S)
    &= \frac{\abs{E(S, \bar{S})}}{\min(d(S), d(\bar{S}))}
    = \frac{\abs{S} \cdot \abs{\bar{S}}}{\min((n-1) \abs{S}, (n-1) \abs{\bar{S}})} \\
    &= \begin{cases}
        \frac{\abs{\bar{S}}}{n-1}, & \text{if } \abs{S} < \abs{\bar{S}} \\
        \frac{\abs{S}}{n-1}, & \text{otherwise}
    \end{cases} \\
    &\leq \frac{n/2}{n-1} \approx \frac{1}{2} \qquad\text{for large } n
    \\
    N_{cut}(S)
    &= \frac{\abs{E(S, \bar{S})}}{d(S)} + \frac{\abs{E(\bar{S}, S)}}{d(\bar{S})}
    = \abs{S} \abs{\bar{S}} \left( \frac{1}{(n-1) \abs{S}} + \frac{1}{(n-1) \abs{\bar{S}}} \right) \\
    &= \frac{\bar{S} + \abs{S}}{n-1}
    = \frac{n}{n-1} \approx 1 \qquad\text{for large } n
\end{aligned}
$$

**Graph Laplacian.**
Let $$A \in \{0,1\}^{n \times n}$$ denote the symmetric adjacency matrix

$$
    A_{ij} = \begin{cases}
        1, & \text{if } \{i,j\} \in E \\
        0, & \text{otherwise}.
    \end{cases}
$$

Let $$D = \diag(d_1, \dotsc, d_n) \in \R^{n \times n}$$ be the degree matrix. The graph Laplacian is defined as $$L = D - A$$, and the normalized graph Laplacian is

$$
    \bar{L} = D^{-1/2} L D^{-1/2} = I - D^{-1/2} A D^{-1/2}.
$$

Both the Laplacian and normalized Laplacian matrices are symmetric. By the Real Spectral Theorem, let $$\lambda_1 \leq \dotsb \leq \lambda_n$$ denote the eigenvalues of the normalized Laplacian, with corresponding orthogonal eigenvectors $$v^{(1)}, \dotsc, v^{(n)}$$. With a slight abuse of terminology, we call $$v^{(k)}$$ the $$k$$-th smallest eigenvector (because it corresponds to the $$k$$-th smallest eigenvalue). It can be shown that $$v^{(1)} = D^{1/2} \one$$. Then,

$$
    \lambda_2
    = \min_{v \perp v^{(1)}} \frac{v^T \bar{L} v}{v^T v}
    = \min_{y \perp D \one} \frac{y^T L y}{y^T D y}
$$

where the first equality is from the variational characterization of eigenvalues (Courant-Fischer Theorem), and the second equality comes from substituting $$y = D^{-1/2} v$$.



## 2-partition: Normalized Cut

The graph clustering problem, as posed by Shi and Malik (2000) [[1]](#references), aims to find a set $$S^*$$ that minimizes the normalized cut:

$$
    S^* = \argmin_{S \subset V} N_{cut}(S)
$$

It is easy to show that for any $$S \subset V$$ with $$S \neq \emptyset$$, then

$$
    N_{cut}(S) = \frac{y^T L y}{y^T D y}
    \quad\text{where}\quad
    y_i = \begin{cases}
        \frac{1}{d(S)}, & \text{if } i \in S \\
        \frac{-1}{d(\bar{S})}, & \text{otherwise}.
    \end{cases}
$$

The constraint can be relaxed to $$y \perp D \one$$, so

$$
    \lambda_2
    = \min_{y \perp D \one} \frac{y^T L y}{y^T D y}
    \leq N_{cut}(S).
$$

The explicit constraint $$y \perp D \one$$ along with the implicit constraint $$y \neq \zero$$ (because of the $$y^T D y$$ in the denominator) also imply that $$y$$ must have positive and negative entries, and since the numerator expands as

$$
    y^T L y = \sum_{\{i,j\} \in E} (y_i - y_j)^2,
$$

the intuitive minimizer has $$y_i \approx c_1 > 0 \ \forall i \in S^*$$ and $$y_j \approx c_2 < 0 \ \forall j \not\in S^*$$, for some constants $$c_1$$ and $$c_2$$.

If $$y$$ is the solution to the relaxed optimization problem, then entries of the second eigenvector $$v^{(2)} = D^{1/2} y$$ of the normalized Laplacian have the same sign as in $$y$$. Thus, the sign of entries in $$v^{(2)}$$ provide an approximately optimal clustering of the nodes in $$V$$ (according to the normalized cut).



## 2-partition: Graph Expansion

Besides the connection to the optimal normalized cut, the second eigenvalue $$\lambda_2$$ is also related to the problem of finding a set of nodes that minimizes expansion. We can define the expansion of a graph as

$$
    \phi(G) = \min_{S \subseteq V} \phi(S).
$$

A standard result in spectral graph theory is the Cheeger inequality (Theorem 1 in [[2]](#references)):

**Theorem 1 (Cheeger inequality)**: For any undirected graph $$G$$,
$$
    \frac{\lambda_2}{2} \leq \phi(G) \leq \sqrt{2 \lambda_2},
$$
equivalently written as

$$
    \frac{\phi(G)^2}{2} \leq \lambda_2 \leq 2 \phi(G).
$$

The standard proof for the right-side inequality also provides an algorithm for finding a set $$S \subset V$$ that satisfies

$$
    \phi(G) \leq \phi(S) \leq \sqrt{2 \lambda_2}.
$$


## k-Way Clustering

The 2-way partitioning algorithms provide a simple recursive technique to perform *k*-way partitioning. First, partition the graph into two clusters, then recursively run the 2-way partitioning algorithm separately on the subgraph for each cluster. However, this technique ignores the higher-order spectral information.

Instead, several algorithms have been proposed to explicitly use the higher-order spectral information for finding $$k$$-partitions that minimize generalized notions of normalized cut or graph expansion.

Given a $$k$$-partition $$\{S_i\}_{i=1}^k$$, define the $$k$$-way normalized cut criterion as

$$
    N_{cut,k}(S) = \sum_{i=1}^k \frac{\abs{E(S_i, \bar{S_i})}}{d(S_i)}.
$$

In [[1]](#references), Shi and Malik propose the following greedy heuristic algorithm for finding a good $$k$$-partition. Unfortunately, they provide neither theoretical nor empirical evidence about how well this algorithm works.

1. Calculate the $$n$$ eigenvectors $$y^{(1)}, \dotsc, y^{(n)}$$ of the generalized eigenvector problem $$Ly = \lambda D y$$. Note that these eigenvectors correspond to the same eigenvalues $$\lambda_1, \dotsc, \lambda_n$$ of the normalized Laplacian matrix.
2. For each node $$i$$, define its feature representation $$f(i) = [y^{(1)}_i, \dotsc, y^{(n)}_i]$$.
3. Use a standard clustering algorithm such as $$k$$-means on the node feature representations to group the nodes into $$k' \geq k$$ clusters.
4. Iteratively merge clusters until there are only $$k$$ clusters left, where each iteration merges the two clusters that greedily minimize the $$N_{cut,k}$$ criterion.

In [[3]](#references), Ng et al. (2002) propose a similar algorithm. Instead of the unnormalized Laplacian, they use the normalized Laplacian $$\bar{L}$$:

1. For each node $$i$$, define its feature representation $$f(i) = [v^{(1)}_i, \dotsc, v^{(k)}_i]$$ using the $$k$$ smallest eigenvectors.
2. Use a standard clustering algorithm such as $$k$$-means on the node feature representations to group the nodes into $$k$$ clusters.

Importantly, Ng et al. state a theorem (albeit without an accompanying proof) that under certain assumptions on the structure of the graph, the feature representations of the nodes can be roughly clustered around $$k$$ orthogonal vectors on the $$k$$-dimensional unit sphere.

Although these heuristic algorithms worked well in practice (some described them as ["unreasonably effective"](https://www.youtube.com/watch?v=8XJes6XFjxM)), until relatively recently there were only limited guarantees on how well the outputs of these algorithms approximated the optimal $$k$$-partition. However, in 2012, Lee et al. [[4]](#references) proved a significant result which generalized the Cheeger inequality to higher-order eigenvalues. Specifically, Lee et al. proved the following result:

**Theorem 2**: For every undirected graph $$G$$ and every $$k \in \N$$,

$$
    \frac{\lambda_k}{2} \leq \rho_G(k) \leq O(k^2) \sqrt{\lambda_k},
$$

where $$\rho_G(k)$$ is the $$k$$-way expansion constant

$$
    \rho_G(k) = \min_{\text{$k$-partition } S_1, \dotsc, S_k} \max\{ \chi(S_i) \mid i=1, \dotsc, k \}
$$

and $$\chi(S)$$ is defined as

$$
    \chi(S) = \frac{\abs{E(S, \bar{S})}}{d(S)}.
$$

It is clear that $$\rho_G(2) = \phi(G)$$. Furthermore, $$\rho_G(k) = 0$$ if and only if $$G$$ has at least $$k$$ disconnected components (set each $$S_i$$ to be a connected component, so $$\abs{E(S_i, \bar{S_i})} = 0$$). Thus, the theorem matches the standard result that $$\lambda_k = 0$$ if and only if $$G$$ has at least $$k$$ disconnected components.

The analysis of the proof leads to a randomized algorithm for finding a $$k$$-partition, which I describe here at a high level:

1. Compute $$y^{(i)} = D^{-1/2} v^{(i)}$$ for $$i = 1, \dotsc, 2k$$. These are the eigenvectors from the generalized eigenvector problem $$Ly = \lambda D y$$, and they correspond to the same eigenvalues $$\lambda_1, \dotsc, \lambda_{2k}$$ of the normalized Laplacian matrix.
2. For each node $$i$$, define its feature representation $$f(i) = [y^{(1)}_i, \dotsc, y^{(n)}_{2k}]$$.
3. Randomly project the feature vectors from dimension $$\R^{2k}$$ into the $$h$$-dimensional unit ball in $$\R^h$$, where $$h = O(\log k)$$. To do this, compute the dot product of $$f(i)$$ with $$h$$ random Gaussian vectors.
4. Randomly sample a sequence of "centroids" on the $$h$$-dimensional unit ball, and assign each node to the closest centroid.
5. Iteratively merge the clusters from smallest weight to largest weight, until there are only $$k' = 1.5k$$ clusters left. The weight of a cluster is the sum of the squared-norms of the node features in the cluster.
6. For each of the $$k'$$ clusters $$S_i$$, determine a threshold $$\tau$$ such that

    $$
        \hat{S}_i = \left\{v \in S_i \mid \norm{f^*(v)}^2 \geq \tau \right\}
    $$

    has the least expansion. Among the sets $$\hat{S}_1, \dotsc, \hat{S}_{k'}$$, choose the $$k$$ with smallest expansion.

Notably, this algorithm is somewhat similar what Shi and Malik described, using entries from the generalized eigenvectors of the Laplacian matrix as initial feature representations, then clustering and merging the nodes based on these feature representations. While Lee et al. relied on random projections (step 3) and random partitioning (step 4) to derive their result, they posed the open question of whether a $$k$$-means algorithm would work as well.

Follow-up work in 2015 by Peng et al. [[5]](#references) essentially answered this question affirmatively in the case where node feature representations use the $$k$$ smallest eigenvectors of the normalized Laplacian:

$$
    f(i) \propto [v^{(1)}_i, \dotsc, v^{(k)}_i].
$$

This is nearly identical to the Ng et al. algorithm, except here only the $$k$$ smallest eigenvectors are used, instead of all $$n$$ eigenvectors. Using the generalized Cheeger inequality, Peng et al. proved (Theorem 1.2 in [[5]](#references)) that this Spectral $$k$$-Means Algorithm produces a $$k$$-partition $$\{S_i\}_{i=1}^k$$ which satisfies

$$
    \phi(S_i) = O(\phi(S_i^*) + \alpha k^3 \rho_G(k) / \lambda_{k+1})
$$

where $$S_i$$ is the optimal partition (for $$\rho_G(k)$$) and $$\alpha$$ is the approximation ratio of the $$k$$-means algorithm.

## Summary

While $$k$$-way spectral clustering has seen widespread empirical success, the theoretical results by Lee et al. [[4]](#references) and Peng et al. [[5]](#references) explain why these methods work so well. 


## References

[1] Shi, Jianbo, and Jitendra Malik. "Normalized Cuts and Image Segmentation." *IEEE Transactions on Pattern Analysis and Machine Intelligence* 22, no. 8 (2000): 888-905. [(link)](https://doi.org/10.1109/34.868688)

* Defines the normalized cut.

[2] Chung, Fan. "Four proofs for the Cheeger inequality and graph partition algorithms." In *Proceedings of ICCM*, vol. 2, p. 378. 2007. [(link)](http://www.math.ucsd.edu/~fan/wp/heaticcm.pdf)

* Proves the Cheeger inequality

[3] Ng, Andrew Y., Michael I. Jordan, and Yair Weiss. "On Spectral Clustering: Analysis and an algorithm." *Advances in Neural Information Processing Systems* 2 (2002): 849-856. [(link)](https://dl.acm.org/doi/10.5555/2980539.2980649)

* Describes the original spectral $$k$$-means clustering algorithm

[4] Lee, James R., Shayan Oveis Gharan, and Luca Trevisan. "Multiway Spectral Partitioning and Higher-Order Cheeger Inequalities." *Journal of the ACM (JACM)* 61, no. 6 (2014): 1-30. [(link)](https://dl.acm.org/doi/abs/10.1145/2665063)

* Proves the generalized Cheeger inequality for higher-order eigenvalues

[5] Peng, Richard, He Sun, and Luca Zanetti. "Partitioning well-clustered graphs: Spectral clustering works!." In *Conference on Learning Theory*, pp. 1423-1455. PMLR, 2015. [(link)](http://proceedings.mlr.press/v40/Peng15.html)

* Applies the generalized Cheeger inequality to the spectral $$k$$-means clustering algorithm problem