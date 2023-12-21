---
title: Simplified DistFlow Equations
layout: post
use_math: true
use_toc: true
last_updated: 2023-10-24
tags: [control]
excerpt: Recently, I worked on the voltage control problem for radial distribution grids (see [here](https://dl.acm.org/doi/10.1145/3538637.3538853)). More simply, the problem is to keep voltages in an electric grid within a fixed range at all locations in the grid, under the assumption that the grid is radial, meaning tree-structured. Like most other voltage control algorithms, I used the linear "Simplified DistFlow" model. It took me a while to understand the math behind this model, and I hope this post demystifies some of that complexity.
---

$$
\newcommand{\i}{\mathbf{i}}  % complex number i
\renewcommand{\Re}{\mathsf{Re}}  % real component
\renewcommand{\Im}{\mathsf{Im}}  % imaginary component
\DeclareMathOperator{\diag}{diag}  % diagonal
\newcommand{\Imax}{I_\max}  % current amplitude
\newcommand{\Vmax}{V_\max}  % voltage amplitude
$$

This post assumes familiarity with:

- complex numbers and trigonometry
- basic electromagnetism physics (*e.g.*, [Fundamentals of Physics](https://en.wikipedia.org/wiki/Fundamentals_of_Physics))
- basic linear algebra (*e.g.*, [Linear Algebra Done Right, 3e](https://doi.org/10.1007/978-3-319-11080-6))

This post is based on excellent lecture notes on power systems by Prof. Steven Low, found here: [http://netlab.caltech.edu/book/book.html](http://netlab.caltech.edu/book/book.html).


## Review of complex numbers

Here is a quick refresher on complex numbers. Let $$\i = \sqrt{-1}$$, and let $$x,y \in \C$$, with $$x = a + \i b$$.
- The real component is denoted $$\Re(x) := a$$.
- The imaginary component is denoted $$\Im(x) := b$$.
- The magnitude is $$\abs{x} := \sqrt{a^2 + b^2}$$.
- The complex conjugate is $$x^* := a - \i b$$.
- The angle of $$x$$ is $$\angle x := \tan^{-1}(b/a)$$
- Euler's formula: $$e^{\i \theta} = \cos\theta + \i \sin\theta$$
  - If $$\theta = \angle x$$, then $$x = \abs{x} e^{\i \theta}$$.
  - $$\abs{e^{\i \theta}} = \sqrt{\cos^2 \theta + \sin^2 \theta} = 1$$ for all $$\theta$$
- Useful identities:
  - binomial expansion: $$\abs{x+y}^2 = \abs{x}^2 + 2 \Re(xy^*) + \abs{y}^2$$
  - complex conjugate is distributive: $$(xy)^* = x^* y^*$$


## Phasors

Consider a sinusoidal voltage $$v(t) = \Vmax \cos(\omega t + \theta_v)$$ where $$\Vmax$$ is the **amplitude**, $$\omega$$ is the **frequency**, and $$\theta_v$$ is the **phase**. The units of each variable are as follows:

variable(s)         | units
--------------------|------
$$v(t)$$, $$\Vmax$$ | volts (V)
$$\omega$$          | radians/sec (often written s$$^{-1}$$ without the radians)
$$t$$               | seconds (s)
$$\theta_v$$        | radians (often written without units)

We will make the **steady-state assumption** that the frequency $$\omega$$ at all points in the electric grid are *nominal*, and that this nominal frequency is known to everyone. One **period** is $$T = \frac{2\pi \ \text{rad}}{\omega}$$ seconds. In the USA, the nominal frequency of electricity is 60Hz, so

$$
\begin{aligned}
\omega &= 60 \cdot 2\pi = 120\pi \ \text{s}^{-1} \\
T &= \frac{2\pi}{120\pi} = \frac{1}{60} \ \text{s}
\end{aligned}
$$

In reality, all electrical measurements such as voltage are real-valued. However, when working with AC power, it is often convenient to use complex-valued **phasor** representations of electrical quantities. For the sinusoidal voltage above, its phasor representation is defined as

$$ V := \frac{\Vmax}{\sqrt 2} e^{\i \theta_v} \in \C. $$

The phasor $$V$$ has the same units (volts) as $$v(t)$$ in the time domain. The **magnitude** of the phasor is the coefficient $$\abs{V} = \frac{\Vmax}{\sqrt 2}$$.

Note that the phasor representation does not encode frequency information, which is fine because we know the nominal frequency. The relationship between the phasor representation and the time-domain representation is given by

$$
\Re(\sqrt{2} V e^{\i \omega t})
= \Re(\Vmax e^{\i (\omega t + \theta_v)})
= \Vmax \cos(\omega t + \theta_v)
= v(t).
$$

Likewise, we can define a phasor representation for electrical current (in units of ampere):
- time domain: $$i(t) = \Imax \cos(\omega t + \theta_i)$$
- phasor representation: $$I := \frac{\Imax}{\sqrt 2} e^{\i \theta_i}$$


## Impedance

The classical dynamics equations for resistors, inductors, and capacitors can be written using  phasor domain representations.

|           | time domain ($$\R$$)                | phasor domain ($$\C$$)       | complex impedance $$Z$$ ($$\C$$)
|-----------|-------------------------------------|------------------------------|---------------------------------
| resistor  | $$v(t) = R \cdot i(t)$$             | $$V = R \cdot I$$            | $$Z_R = R$$
| inductor  | $$v(t) = L \cdot \deriv{}{t} i(t)$$ | $$V = (\i \omega L) I$$      | $$Z_L = \i \omega L$$
| capacitor | $$i(t) = C \cdot \deriv{}{t} v(t)$$ | $$V = (\i \omega C)^{-1} I$$ | $$Z_C = (\i \omega C)^{-1}$$

The phasor descriptions of resistors, inductors, and capacitors obey **Ohm's law** in phasor form, $$V = Z \cdot I$$, where $$Z \in \C$$ is called the **impedance** (in Ohms $$\Omega$$) of the circuit element. (See proofs below.)

Re-arranging Ohm's law yields $$Z = \frac{V}{I} = \frac{\abs{V}}{\abs{I}} e^{\i (\theta_v - \theta_i)}$$, with $$\abs{Z} = \frac{\abs{V}}{\abs{I}}$$ and $$\angle Z = \theta_v - \theta_i$$.

From complex impedance $$Z$$, we can define 3 quantities:
- **resistance** (in $$\Omega$$), the real component, $$r := \Re(Z)$$
- **reactance** (in $$\Omega$$), the complex component, $$x := \Im(Z)$$
- **admittance** (in siemens S, or equivalently $$\Omega^{-1}$$), its inverse, $$Y = Z^{-1} \in \C$$.

*Proof for resistor.* From classic Ohm's law, we have $$v(t) = R \cdot i(t)$$. Now, substitute in the phasor representations:

$$
\Re(\sqrt{2} V e^{\i \omega t})
= R \cdot \Re(\sqrt{2} I e^{\i \omega t}).
$$

This implies $$V = R \cdot I$$. $$\blacksquare$$

*Proof for inductor.* Using $$-\sin x = \cos(x + \pi/2)$$, we have

$$
\begin{aligned}
\deriv{}{t} i(t)
&= \deriv{}{t} \Imax \cos(\omega t + \theta_i)
= -\omega \Imax \sin(\omega t + \theta_i) \\
&= \omega \Imax \cos\left(\omega t + \theta_i + \frac{\pi}{2}\right) \\
&= \omega i\left(t + \frac{\pi/2}{\omega}\right)
\end{aligned}
$$

Substituting this into the inductor dynamics $$v(t) = L \cdot \deriv{}{t} i(t)$$ and using the phasor representations yields

$$
\begin{aligned}
\Re(\sqrt{2} V e^{\i \omega t})
&= \Re(L \omega \cdot \sqrt{2} I e^{\i \omega (t + \frac{\pi/2}{\omega})}) \\
&= \Re(\sqrt{2} \omega L I e^{\i \omega t} \underbrace{e^{\i \pi/2}}_{\cos\frac{\pi}{2} + \i \sin\frac{\pi}{2} = \i}) \\
&= \Re(\sqrt{2} \i \omega L I e^{\i \omega t})
\end{aligned}
$$

This implies $$V = (\i \omega L) I$$. $$\blacksquare$$

*Proof for capacitor.* Similar to proof for inductor. $$\blacksquare$$


## Complex power

Power is defined as voltage $$\times$$ current. In the time domain, **instantaneous power** (in watts W) is

$$
\begin{aligned}
p(t) &:= v(t) i(t)
= \Vmax \cos(\omega t + \theta_v) \cdot \Imax \cos(\omega t + \theta_i) \\
&= \frac{\Vmax \Imax}{2} [\cos(\theta_v - \theta_i) + \cos(2 \omega t + \theta_v + \theta_i)]
\end{aligned}
$$

where we use the identity $$\cos x \cos y = \frac{1}{2}[\cos(x-y) + \cos(x+y)]$$. Let $$\phi := \theta_v - \theta_i$$ represent the phase difference. Then, we define **complex power** as

$$
\begin{aligned}
S &:= V I^*
= \frac{\Vmax}{\sqrt 2} e^{\i \theta_v} \cdot \frac{\Imax}{\sqrt 2} e^{-\i \theta_i} \\
&= \frac{\Vmax \Imax}{2} e^{\i (\theta_v - \theta_i)}
= \abs{V} \abs{I} e^{\i \phi}.
\end{aligned}
$$

Complex power has units volt-ampere (V·A), which is dimensionally equivalent to watt (W) but emphasizes that the quantity is complex power instead of instantaneous power. From complex power, we can define 3 quantities:
- **active power** (in W), the real component, $$P := \Re(S) = \abs{V} \abs{I} \cos\phi$$
- **reactive power** (in V·A), the complex component, $$Q := \Im(S) = \abs{V} \abs{I} \sin\phi$$
- **apparent power** (in V·A), the magnitude, $$\abs{S} = \abs{V} \abs{I}$$

Thus, we have $$S = P + \i Q$$. Note that $$S$$ is not a phasor, since $$\sqrt{2} \abs{S} \cos(\omega t + \phi) \neq p(t)$$.


## DistFlow Equations

Now, we can finally write down the nonlinear DistFlow equations. Consider a radial electricity distribution network $$G = (\Ncal, \Ecal)$$ where $$\Ncal = \{0, 1, \dotsc, n\}$$ is a set of nodes (called **buses**) and $$\Ecal \subset \Ncal \times \Ncal$$ is a set of directed edges (called **lines**) that point away from bus 0. Let bus 0 (called the **slack bus**) be the root of the tree. Since the network is tree-structured, there are $$\abs\Ecal = n$$ lines since every bus has exactly 1 parent, except bus 0 which has no parent.

For every bus $$j \in \Ncal$$ and line $$j \to k \in \Ecal$$, we write:
- squared voltage magnitude $$v_j = \abs{V_j}^2 $$ (units V<sup>2</sup>)
- squared current magnitude $$l_{jk} = \abs{I_{jk}}^2$$ (units A<sup>2</sup>)
- complex impedance $$z_{jk} = r_{jk} + \i x_{jk}$$ (units $$\Omega$$)
- complex power flow $$S_{jk} = P_{jk} + \i Q_{jk}$$ (units V·A)
- complex power injection $$s_j = p_j + \i q_j$$ (units V·A)

The **DistFlow model** comprises of 3 equations, where bus $$i$$ is the parent of bus $$j$$:

$$
\begin{aligned}
\sum_{k: j \to k} S_{jk} &= S_{ij} - z_{ij} l_{ij} + s_j
    && \forall j \in \Ncal & (1) \\
v_j - v_k &= 2 \Re(z_{jk}^* S_{jk}) - \abs{z_{jk}}^2 l_{jk}
    && \forall (j \to k) \in \Ecal & (2) \\
v_j l_{jk} &= \abs{S_{jk}}^2
    && \forall (j \to k) \in \Ecal & (3)
\end{aligned}
$$

Equation (1) enforces power balance. The LHS is power leaving bus $$j$$. The RHS consists of three terms: power sent from the parent bus $$i$$ minus the power lost to transmission, and the power injected at bus $$j$$. When $$j = 0$$, we set $$S_{i0} = 0$$ and $$l_{i0} = 0$$.

Equation (2) can be derived from the phasor form of Ohm's law and by using the definition of complex power ($$S_{jk} = V_j I_{jk}^*$$):

$$
\begin{aligned}
&& V_j - V_k &= I_{jk} z_{jk} \\
&\implies & V_k &= V_j - I_{jk} z_{jk} \\
&\implies & v_k &= \abs{V_k}^2 = \abs{V_j - I_{jk} z_{jk}}^2 \\
&&&= \abs{V_j}^2 - 2 \Re(V_j (I_{jk} z_{jk})^*) + \abs{I_{jk} z_{jk}}^2 \\
&&&= v_j - 2 \Re(V_j I_{jk}^* z_{jk}^*) + \abs{z_{jk}}^2 l_{jk} \\
&&&= v_j - 2 \Re(z_{jk}^* S_{jk}) + \abs{z_{jk}}^2 l_{jk}
\end{aligned}
$$

Equation (3) comes from the definition of complex power:

$$
\abs{S_{jk}}^2
= \abs{V_j I_{jk}^*}^2
= \abs{V_j}^2 \abs{I_{jk}^*}^2
= v_j l_{jk}.
$$

Equivalently, we can write the DistFlow equations in real form:

$$
\begin{aligned}
\sum_{k: j \to k} P_{jk} &= P_{ij} - r_{ij} l_{ij} + p_j
    && \forall j \in \Ncal & (a) \\
\sum_{k: j \to k} Q_{jk} &= Q_{ij} - x_{ij} l_{ij} + q_j
    && \forall j \in \Ncal & (b) \\
v_j - v_k &= 2 (r_{jk} P_{jk} + x_{jk} Q_{jk}) - (r_{jk}^2 + x_{jk}^2) l_{jk}
    && \forall (j \to k) \in \Ecal & (c) \\
v_j l_{jk} &= P_{jk}^2 + Q_{jk}^2
    && \forall (j \to k) \in \Ecal & (d)
\end{aligned}
$$

Often, Equation (d) is eliminated by substituting into Equations (a) and (b):

$$
\begin{aligned}
\sum_{k: j \to k} P_{jk} &= P_{ij} - r_{ij} \frac{P_{ij}^2 + Q_{ij}^2}{v_i} + p_j
    && \forall j \in \Ncal & (a') \\
\sum_{k: j \to k} Q_{jk} &= Q_{ij} - x_{ij} \frac{P_{ij}^2 + Q_{ij}^2}{v_i} + q_j
    && \forall j \in \Ncal & (b') \\
v_j - v_k &= 2 (r_{jk} P_{jk} + x_{jk} Q_{jk}) - (r_{jk}^2 + x_{jk}^2) l_{jk}
    && \forall (j \to k) \in \Ecal & (c) \\
\end{aligned}
$$

The **power flow problem** refers to solving for voltages and power flows (and optionally current), given impedances:

|                  | complex form                                                               | real form
|------------------|----------------------------------------------------------------------------|----------------
| given parameters | $$z_{jk} \in \C$$                                                          | $$r_{jk}, x_{jk} \in \R$$
| variables        | $$s \in \C^{n+1}, v \in \R^{n+1}, l \in \R^\abs\Ecal, S \in \C^\abs\Ecal$$ | $$p,q,v \in \R^{n+1}$$, $$l, P, Q \in \R^\abs\Ecal$$
| typical problem  | given $$(v_0, s)$$, solve for $$(v, l, S)$$                                | given $$(v_0, p, q)$$, solve for $$(v,l,P,Q)$$

The radial DistFlow equations are *nonlinear* in the variables listed above:
- complex form: Equation (3) $$v_j l_{jk} = \abs{S_{jk}}^2$$ is nonlinear
- real form: Equation (d) $$v_j l_{jk} = P_{jk}^2 + Q_{jk}^2$$ is nonlinear, as are the substituted versions (a') and (b')


## Simplified DistFlow Model

It is reasonable to assume that the line losses $$z_{jk} l_{jk}$$ are small compared with the line power flows $$S_{jk}$$. Therefore, we can approximate $$z_{jk} l_{jk} \approx 0$$ which yields the **simplified DistFlow model**, also called the **linearized DistFlow model**. This model was first introduced in

> M. Baran and F. F. Wu, "Optimal sizing of capacitors placed on a radial distribution system," in _IEEE Transactions on Power Delivery_, vol. 4, no. 1, pp. 735-743, Jan. 1989, doi: 10.1109/61.19266. [https://ieeexplore.ieee.org/document/19266](https://ieeexplore.ieee.org/document/19266).

In complex form:

$$
\begin{aligned}
\sum_{k: j \to k} S_{jk} &= S_{ij} + s_j
    && \forall j \in \Ncal & (1_\text{lin}) \\
v_j - v_k &= 2 \Re(z_{jk}^* S_{jk})
    && \forall (j \to k) \in \Ecal & (2_\text{lin})
\end{aligned}
$$

Equivalently, in real form:

$$
\begin{aligned}
\sum_{k: j \to k} P_{jk} &= P_{ij} + p_j
    && \forall j \in \Ncal & (a_\text{lin}) \\
\sum_{k: j \to k} Q_{jk} &= Q_{ij} + q_j
    && \forall j \in \Ncal & (b_\text{lin}) \\
v_j - v_k &= 2 (r_{jk} P_{jk} + x_{jk} Q_{jk})
    && \forall (j \to k) \in \Ecal & (c_\text{lin})
\end{aligned}
$$

Consider the typical problem in real form, where we are given the impedances $$r,x \in \R^\abs\Ecal$$, the slack bus square voltage magnitude $$v_0 \in \R$$, as well as the power injections $$p, q \in \R^{n+1}$$. The $$3n+2$$ equations are sufficient to solve for the $$3n$$ remaining variables $$(v_{1:n} \in \R^n,\ P,Q \in \R^\abs\Ecal = \R^n)$$. (Here, we ignore the line currents $$l_{jk}$$.)

These linear equations have a convenient matrix representation. Let $$C \in \{-1, 0, 1\}^{(n+1) \times n}$$ denote the bus-by-line incidence matrix, defined by

$$
C_{jl} := \begin{cases}
    1, & \text{if bus $j$ is the start of line $l$} \\
    -1, & \text{if bus $j$ is the end of line $l$} \\
    0, & \text{otherwise}.
\end{cases}
$$

Define matrices $$D_r := \diag(r_l, l \in \Ecal),\ D_x := \diag(x_l, l \in \Ecal) \in \R^{n \times n}$$. Then the linear DistFlow equations can be written as

$$
\begin{aligned}
    s &= CS \\
    C^\top v &= 2 (D_r P + D_x Q)
\end{aligned}
$$

If we let $$c_0^\top$$ denote the 1st row of the $$C$$ matrix and $$\hat C \in \{-1, 0, 1\}^{n \times n}$$ denote the remaining rows

$$
C = \begin{bmatrix}
c_0^\top \\
\hat C
\end{bmatrix}
$$

then we have

$$
\begin{aligned}
    s_0 &= c_0^\top S \\
    s_{1:n} &= \hat{C} S \\
    v_0 c_0 + \hat{C}^\top v_{1:n} &= 2 (D_r P + D_x Q)
\end{aligned}
$$

For each bus $$j$$, let $$\Pcal_j \subseteq \Ecal$$ be the directed path from bus 0 to bus $$j$$. We now show that $$\hat{C}$$ is invertible.

**Lemma:** The inverse of $$\hat{C}$$ is given by

$$
[\hat{C}^{-1}]_{lj} = \begin{cases}
    -1, & \text{if } l \in \Pcal_j \\
    0, & \text{otherwise}.
\end{cases}
$$

*Proof*:

$$
[\hat{C} \hat{C}^{-1}]_{jk}
= \sum_{l \in \Ecal} \hat{C}_{jl} (\hat{C}^{-1})_{lk}
= \sum_{l \in \Pcal_k} -\hat{C}_{jl}
$$

Now, consider 3 cases.

1. Suppose $$j = k$$. Let bus $$i$$ be the parent of bus $$j$$. Then the only line in $$\Pcal_k$$ that $$j$$ is part of is $$l = (i \to j)$$. Since $$j$$ is the end of line $$l$$, $$\hat{C}_{jl} = -1$$. Thus, $$[\hat{C} \hat{C}^{-1}]_{jj} = - \hat{C}_{j, (i \to j)} = -(-1) = 1$$.

2. Suppose $$j \neq k$$, and $$j$$ is not on the path to $$k$$. Then $$\hat{C}_{jl} = 0$$ for every $$l \in \Pcal_k$$. Thus, $$[\hat{C} \hat{C}^{-1}]_{jk} = 0$$.

3. Suppose $$j \neq k$$, and $$j$$ is on the path to $$k$$. Then $$j$$ is part of 2 lines in $$\Pcal_k$$, once as the starting bus and once as the end bus. Thus, $$[\hat{C} \hat{C}^{-1}]_{jk} = -\hat{C}_{j,(\cdot \to j)} - \hat{C}_{j,(j \to \cdot)} = -(-1) - 1 = 0$$.

We have shown that $$[\hat{C} \hat{C}^{-1}]_{jk} = \one[j=k]$$ as desired. $$\blacksquare$$

Since $$\hat{C}$$ is invertible, we can directly solve for $$(v_{1:n}, S)$$ as

$$
\begin{aligned}
    S &= \hat{C}^{-1} s_{1:n} \\
    v_{1:n} &= \hat{C}^{-\top}(2 D_r P + 2 D_x Q - v_0 c_0)
\end{aligned}
$$

We have

$$
\begin{aligned}
    (\hat{C}^{-\top} c_0)_j
    &= \sum_{l \in \Ecal} (\hat{C}^{-\top})_{jl} (c_0)_l
    = \sum_{l \in \Ecal} (\hat{C}^{-1})_{lj} C_{0l} \\
    &= \sum_{(0 \to k) \in \Ecal} (\hat{C}^{-1})_{(0 \to k),j}
    = \sum_{(0 \to k) \in \Pcal_j} -1 \\
    &= -1
\end{aligned}
$$

since exactly one line of the form $$(0 \to k)$$ is part of $$\Pcal_j$$. Thus, $$\hat{C}^{-\top} c_0 = -\one$$. Furthermore, in real form, the equation $$S = \hat{C}^{-1} s_{1:n}$$ splits into $$P = \hat{C}^{-1} p_{1:n}$$ and $$Q = \hat{C}^{-1} q_{1:n}$$. Substituting these into the equation for $$v_{1:n}$$ yields

$$
\begin{aligned}
    v_{1:n}
    &= 2 \hat{C}^{-\top} D_r \hat{C}^{-1} p_{1:n} + 2 \hat{C}^{-\top} D_x \hat{C}^{-1} q_{1:n} + v_0 \one \\
    &= v_0 \one + 2 (R p_{1:n} + X q_{1:n})
\end{aligned}
$$

where $$R := \hat{C}^{-\top} D_r \hat{C}^{-1}$$ and $$X := \hat{C}^{-\top} D_x \hat{C}^{-1}$$. Since every $$r_{jk}, x_{jk} > 0$$, the matrices $$D_r, D_x$$ are symmetric positive definite. Thus, $$R, X \succ 0$$, since

$$
\forall u \neq \zero:\quad
u^\top R u
= u^\top \hat{C}^{-\top} D_r \hat{C}^{-1} u
= (\hat{C}^{-1} u)^\top D_r (\hat{C}^{-1} u)
> 0.
$$

Finally, we show that the entries of $$R$$ and $$X$$ have a simple interpretation in terms of the resistance and reactance of the lines.

$$
\begin{aligned}
    R_{jm} &= [\hat{C}^{-\top} D_r \hat{C}^{-1}]_{jm}
    = (\hat{C}^{-\top})_{j,:} D_r (\hat{C}^{-1})_{:,m} \\
    &= \sum_{l \in \Ecal} r_l (\hat{C}^{-\top})_{j,l} (\hat{C}^{-1})_{l,m} \\
    &= \sum_{l \in \Ecal} r_l (\hat{C}^{-1})_{l,j} (\hat{C}^{-1})_{l,m} \\
    &= \sum_{l \in \Pcal_j \cap \Pcal_m} r_l (-1) (-1) \\
    &= \sum_{l \in \Pcal_j \cap \Pcal_m} r_l
\end{aligned}
$$

and likewise, $$X_{jm} = \sum_{l \in \Pcal_j \cap \Pcal_m} x_l$$.

Note that it is equivalent to move the factor of 2 into the definition of the $$R$$ and $$X$$ matrices so that

$$
\begin{aligned}
    v_{1:n} &= v_0 \one + R p_{1:n} + X q_{1:n} \\
    R_{jm} &:= 2 \sum_{l \in \Pcal_j \cap \Pcal_m} r_l \\
    X_{jm} &:= 2 \sum_{l \in \Pcal_j \cap \Pcal_m} x_l.
\end{aligned}
$$