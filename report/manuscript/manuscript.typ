#set page(
  paper: "us-letter",
  margin: (top: auto, rest: 0.625in),
  numbering: "1",
  header: [Chapman Thesis #h(1fr) #line(length: 100%)]
)
#set par(justify: true, leading: 0.8em)
#set text(font: "New Computer Modern", size: 11pt)
#set enum(numbering: "1.")
#set heading(numbering: "1.")
#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}
#set document(
  title: [title],
  author: "Nathan Chapman"
)
#set math.equation(numbering: "(1)", supplement: [Eq.])

// #show link: set text(fill: blue, style: "italic")
// #show link: lnk => underline(lnk)

// TITLE
#align(center)[
  #text(size: 14pt)[Scalable Parallel-in-Time Integration for Equations of Motion:\ Particle Production in Analog Cosmologies]
  #v(11pt)
  Nathaniel Chapman#super[1]\
  #super[1]Department of Computer Science, Central Washington University\
  #datetime.today().display("[month repr:long] [day], [year]")
]

#v(18pt)
#align(center)[
  Abstract\
  Abstracty things
]

#outline(indent: auto)
#pagebreak()

= Introduction

== Analog Cosmology

Directly measuring the properties of the universe just after the Big Bang is impossible, as that was almost 14 billion years ago.  Even _indirectly_ measuring these properties is extremely difficult via traditional means.  During these brief moments just after the Big Bang, the universe expanded rapidly in a particular way.  During this expansion there were particles popping in and out of existence, each with its own dynamics (e.g. position and momentum).

What is less difficult is cooling down gases to near absolute-zero (about a billion times colder than empty space).  Gases made of certain atoms or molecules have properties that can be changed to almost any value we want.  Because of this, we can turn our knobs in the lab to make the gas behave in a way that matches a certain mathematical model.

For some types of gases, we can choose how strongly the particles in the gas interact with each other.  It turns out that we can choose a certain interaction strength so that the mathematical model that describes how the gas behaves "bf(exactly) matches the mathematical model of how particles are produced in the universe in the moments just after the Big Bang!  When this happens, we can call this ultra-cold gas an "analog universe".

Because of this mathematical equality, we can effectively observe the particles in the moments just after the Big Bang, but in the lab. Moreover, these observations can be made using a tried-and-true system that has been developed and used over the past thirty years@firstBEC.

Studies have investigated gases with
- phonons with a temporal frequency that is nonlinearly related to the spatial frequency (dispersion relation) @Nonlinear_dispersion_Lorentz_breaking_1 @Nonlinear_dispersion_Lorentz_breaking_2 @Nonlinear_dispersion_Lorentz_breaking_3

- analog massive particles @massive_1 @massive_2 @massive_3

- analog particles with non-zero spin @massive_and_spin_4 @massive_and_spin_5 @massive_and_spin_6 @massive_and_spin_7

- analog universes with different expansion behavior @sudden_transition_1 @sudden_transition_2 @cyclic_cosmology @Experimental_interaction_strength_1

- analog universes with non-zero background velocity @background_velocity_1 @background_velocity_2 @background_velocity_3 @background_velocity_4 @background_velocity_5

- promising experimental realizations @Experimental_candidate_1 @Experimental_candidate_2 @Experimental_interaction_strength_1 @Experimental_interaction_strength_2

Computationally, simulations have had to investigate analog universes of reduced dimension due to the unreasonable time it takes to simulate full-dimensional systems without using high-performance computing.  These simulations have been deemed accurate enough as it is proposed that a full-dimensional simulation would yield qualitatively similar results.  In order to be confident in the level of accuracy of the reduced-dimensional simulations, those results need to be compared to those of a full-dimensional simulation.  This will not only allow a quantification of the error in the reduced-dimensional simulation, but also a measure of the error-to-resource efficiency of a full-dimensional simulation.

Future insight into these analog systems and the fundamental properties of the early universe require computational support.  A readily-usable computational model will not only allow theoretical investigations to make predictions, but also allow experimental research to have a guide on where to go next and have something with which to compare.  The availability of this work is paramount to more efficient and more physically-accurate insight into our universe.

I choose a gas with linear dispersion, analog massless and spin-0 particles, an analog universe undergoing a de Sitter expansion with zero background velocity.  The de Sitter spacetime is chosen because of its significance to modern cosmology and previously predicted particle production (as done by Hawking) @de_Sitter_inhomogeneities @de_Sitter_particle_production_1 @de_Sitter_particle_production_2. Particle production will be calculated with standard methods @particle_production_1 @particle_production_2.  The numerical parameters chosen in this study also follow from previous studies @parameters.  Computational implementations will be done using high-performance methods.

=== BEC Analogs of FLRW Cosmologies
The gas as is outlined is a ground-state Bose-Einstein condensate (BEC) without thermal or quantum fluctuations. The dynamics of the BEC are described by the Gross-Pitaevskii equation (GPE) under a Bogoliubov mean-field approximation (also known as the _nonlinear Schr\u{00F6}dinger equation),_

$ i planck.reduce diff_t psi (t, harpoon(x)) = [-planck.reduce^2 / (2 m) nabla^2 + V_"ext" (x) + U |psi(t, harpoon(x))|^2] psi(t, harpoon(x)). $ <GPE>

The wave function $psi$ can be expanded using a linearized Madelung density-phase representation

$ psi(t, harpoon(x)) = sqrt(n_0 + Delta n(t, harpoon(x))) e^(i (theta_0 + Delta theta(t, harpoon(x))), $ <Madelung>

where $n_0 + Delta n(t, harpoon(x))$ and $theta_0 + Delta theta(t, harpoon(x))$ are the linearized forms of the real density and phase fields, respectively.  Furthermore, $Delta n(t, harpoon(x))$ and $Delta theta(t, harpoon(x))$ are the density and phase perturbations, respectively.

With the Madelung representation defined in @Madelung, the GPE in @GPE becomes @Jain

$ 1 / sqrt(-g) diff_mu [sqrt(-g) g^(mu nu) diff_nu Delta theta] = 0, $ <KG>

where 

$ g_(mu nu) = (n_0 / c)^(2 / (d - 1)) mat(
        -c^2 , dots, 0;
        dots.v, dots.down , dots.v;
        0, dots , delta_(i j)
)
. $ <metric>

@metric can be interpreted as the covariant metric tensor (with determinant $g$) describing an analog, spatially flat, Friedmann-Lemaître-Robertson-Walker universe, $c$ is the speed of sound in the condensate, and $d$ is the number of spatial dimensions.  @KG describes both the phase-perturbations $Delta theta$ of oscillations with low spatial frequency (i.e. low momentum phonons) in the BEC and also the dynamics of a quantum field that produces massless, spin-0 particles.

=== Variable Speed of Sound and Inflation

The time dependence of the system is completely captured in the speed of sound by 

$ c(t)^2 = U(t) n_0 / m = 4 pi planck.reduce ^2 / m^2 n_0 ell(t), $ <speed>

with atoms of mass $m$, scattering length $ell(t)$, and number density $n_0$.  With the dimensionless scaling function $a(t)$, the interaction strength $U(t)$ (or equivalently the scattering length) has time dependence defined by 

$ U(t) equiv U_0 a(t), $

where $U_0 = U(t_0)$ for an initial time $t_0$.  Then @speed becomes 

$ c(t) = c_0 sqrt(a(t)). $

This time dependence of the speed of sound and interaction strength allows us to draw another analogy.  If the speed of sound decreases with time, it would appear as if the space between the source and the observer were increasing.  Similarly, if the speed of sound increases with time, it would appear as if the space between the source and observer is decreasing. With this in mind, if the interaction strength between atoms $U(t)$ decreases with $t$, the analog universe is expanding, and if $U(t)$ increases, the analog universe is contracting.

=== The Field Equation

With the scaling function, @KG becomes #footnote[$(dot(a)(t)) / a(t)$ is the Hubble parameter for an expanding universe with scaling parameter $a(t)$.]

$ #text[2D Field Equation:] diff^2 Delta theta - 3/2 (dot(a)(t)) / a(t) diff_t Delta theta - c_0^2 a(t) nabla^2 Delta theta = 0 $ <fieldEquation2D>
$ #text[3D Field Equation:] diff^2 Delta theta - (dot(a)(t)) / a(t) diff_t Delta theta - c_0^2 a(t) nabla^2 Delta theta = 0 $ <fieldEquation3D>

These equations only differ in the constant coefficient to the first derivative i.e. the dissipative term.  If we consider the #text(style:"italic", [conformal time]) $eta$ defined by $d eta = sqrt(a(t)) d t$, the two-dimensional field equation (@fieldEquation2D) becomes

$ diff_eta^2 Delta theta - 1 / 2 (dot(a)(eta)) / a(eta) diff_eta Delta theta - c_0^2 nabla^2 Delta theta = 0. $ <fieldEquationConformal>

@fieldEquationConformal governs the dynamics of oscillations in the BEC for a time-dependent speed of sound, and the behavior of the massless, spin-0 particles in an expanding universe.

=== Phononic & Free Particle Modes

The phase $Delta theta(t, harpoon(x))$ and density $Delta n(t, harpoon(x))$ perturbation fields can be expanded in a Fourier plane-wave amplitude representation as 

$ Delta theta(t, harpoon(x)) = 1 / sqrt(V) sum_harpoon(k) e^(i harpoon(k) dot.c harpoon(x)) tilde(theta)_harpoon(k)(t) hat(b)_harpoon(k)(t) + e^(-i harpoon(k) dot.c harpoon(x)) tilde(theta)_harpoon(k)^*(t) hat(b)_harpoon(k)^dagger (t) $ <FourierExpansionPhase>

$ Delta n(t, harpoon(x)) = 1 / sqrt(V) sum_harpoon(k) e^(i harpoon(k) dot.c harpoon(x)) tilde(n)_harpoon(k)(t) hat(b)_harpoon(k)(t) + e^(-i harpoon(k) dot.c harpoon(x)) tilde(n)_harpoon(k)^*(t) hat(b)_harpoon(k)^dagger (t) $ <FourierExpansionDensity>

where $harpoon(k)$ is the wave-vector of the phase and density perturbations, $tilde(theta)$ is the discrete Fourier Transform of the phase perturbation, $hat(b)$ and $hat(b)^dagger$ are the annhilation and creation operators, respectively.  From this, there arises two domains to consider#footnote[These domains can also be described as "acoustic" and "Bogoliubov", respectively.]: phononic quasiparticles with linear dispersion, and free-particle-like quasiparticles with quadratic dispersion.

The boundary between phononic and free-particle-like quasiparticles is described by the critical wave-number $k_c$.  The critical wave-number $k_c$ is defined @Jain in terms of the healing length of the BEC $xi$, where

$ xi(t) = planck.reduce / (sqrt(2) m c) = xi_0 / sqrt(a(t)), $ <healing>

$ k_c (t) = 1 / xi(t) = sqrt(a(t)) / xi_0 $ <critical>

Wave-vectors $harpoon(k)$ with wave-number $k = ||harpoon(k)||$ such that $k << k_c$ are called _phononic_#footnote[Phononic quasiparticles have linear dispersion $omega = c k$ characterized by neglecting quantum pressure.].  Likewise, those with $k >> k_c$ are called #text(style: "italic")[free-particle-like]#footnote[Free-particle-like quasiparticles have quadratic dispersion characterized by $omega_k (t)^2 = k^2 / (2 m) ((planck.reduce^2 k^2) / (2 m) + 2 U(t) n_0)$ characteried by including quantum-pressure].

For phononic quasiparticles, the analog between a BEC and an inflationary cosmology is exact.  Inlcuding free-particle-like quasiparticles forces the analog to include "trans-Planckian" effects and analog Lorentz violation@Jain.  For these reasons, this investigation focuses only on phononic quasiparticles; namely wave-vectors $harpoon(k)$ such that $||harpoon(k)|| << k_c$.  Additionally, the free-particle-like regime has nonlinear dispersion which significantly increases the complexity of the field equation@Jain.

Only considering phononic modes, the two-dimensional field (@fieldEquationConformal) then becomes

$ diff_eta^2 tilde(theta)_harpoon(k) - 1 / 2 (dot(a)(eta)) / (a(eta)) diff_eta tilde(theta)_harpoon(k) - c_0^2 k^2 tilde(theta)_harpoon(k) = 0. $ <fieldEquationConformalFourier>

For a de Sitter universe, the scaling function is defined such that $a(t) = e^(-t \/ t_s)$.  Therefore, the field equation for a two-dimensional de Sitter universe is

$ diff_eta^2 tilde(theta)_harpoon(k) - 1 / eta diff_eta tilde(theta)_harpoon(k) + c_0^2 k^2 tilde(theta)_harpoon(k) = 0, $ <fieldEquationdeSitter>

=== Initial Conditions

As the phase and density perturbations need to be continuous at $t = 0$ when the expansion begins, the initial conditions i.e. spacetime boundary conditions are defined by this physical conservation.  Therefore

$ tilde(theta)_harpoon(k)(t = 0) = tilde(theta)_(harpoon(k)0) $ <conditionValue>
$ diff_t tilde(theta)_harpoon(k)(t = 0) = -U / planck.reduce tilde(n)_(harpoon(k)0) $ <conditionDerivative>

where the initial derivative of the phase perturbation's Fourier amplitude (@conditionDerivative) is determined by neglecting the quantum pressure@Jain.

=== Particle Production

The number of particles $N_k (t)$ produced at time $t$ with wave-vector $harpoon(k)$ is described by the equation

$ N_k(t) = |u_k^("out" *)(t) v_k^("exp" *)(t) - v_k^("out" *) u_k^("exp" *)(t)|^2 $ <particleProduction>

where

$ u_k (t) = 1 / (2 sqrt(n_0)) tilde(n)_k (t) + i sqrt(n_0) tilde(theta)_k (t) $ <mixedFourierAmplitudes>
$ v_k (t) = 1 / (2 sqrt(n_0)) tilde(n)_k (t) - i sqrt(n_0) tilde(theta)_k (t), $

"out" and "exp" corresponding to regions of spacetime outside of and inside the expansion of the universe.

To summarize, to calculate the number of particles produced at position $harpoon(x)$ and time $t$ with wave-vector $harpoon(k)$ looks like the following:

+ Solve the field equation (@fieldEquationConformalFourier) for $tilde(theta)_harpoon(k)(t)$
+ Differentiate $tilde(theta)_harpoon(k)(t)$ to get $tilde(n)_harpoon(k)(t)$ as in equation (@conditionDerivative)
+ Combine $tilde(theta)_harpoon(k)(t)$ and $tilde(n)_harpoon(k)(t)$ as in equations (@mixedFourierAmplitudes)
+ Calculate the number of particles at time $t$ with wave-vector $harpoon(k)$ as in @particleProduction

== Computational Physics
- Traditional Methods in evoling Equations of Motion
- Def don't use Runge-Kutta methods
- Symplectic Euler
- Velocity Verlet
- etc.

== Parallel-in-Time Integration

There are 3 traditional ways to parallelize the solution of a computational problem: 
CPU parallelization, 
GPU parallelization, 
and Distributed computing.  
While CPU parallelization is more straightforward to implement, GPU parallelization can allow for runtimes to decrease by many orders of magnitudes.
Even lower run times can be achieved by combining either of these parallization schemes with running them on multiple machines.  This investigation focuses on parallelizing the solution of equations of motion using GPUs and multiple machines.

These approaches can offer massive increases in performance, but only for problems that are well-posed to be parallelized.  Traditionally, initial value problems have been unable to be parallelized due their dependance on causality.  Several methods have been created to overcome this limitation.  These methods include the Parareal algorithm, Multigrid Reduction in Time (MGRIT), Parallel Full Approximtaion Scheme in Space and Time (PFASST).  This investigation focuses on the Parareal algorithm.

= Methods

== The Parareal Algorithm

The four core steps of the parareal algorithm are as follows:

+ *Prepare the subproblems*

  Given an initial value problem $P$:

  $ P = {cal(L)(t, u, diff_t u, diff_t^2 u) = f(t), #h(11pt)  u(0) = u_0,  diff_t u(0) = v_0, #h(11pt) [T, T + Delta T]} $

  where $D = [T, T + Delta T]$. Choose the number of subproblems $N$ (suggested: the number of compute cores). Partition the time domain $D$ into subdomains $D_p$:

  $ D_p = [T + p / N Delta T, T + (p + 1) / N Delta T] = [T_p, T_(p+1)]. $

  Use a coarse propagator $cal(C)_0$ to compute initial solutions ${u_p^0}_p$, ${v_p^0}_p$ defined such that

  $ {u_p^0}_p = {u_0^0, u_1^0, u_2^0, dots, u_(N-1)^0} $
  $ {v_p^0}_p = {v_0^0, v_1^0, v_2^0, dots, v_(N-1)^0} $

  where the superscript denotes that this is the zeroth-iteration

+ *Solve each subproblem in parallel*

  Use a coarse propagator $cal(C)$ (e.g., Symplectic-Euler with a large time step) and a fine propagator $cal(F)$ (e.g. Velocity-Verlet with a small time step). Solve each subproblem $p$ in parallel.

+ *Correct*

  Compute corrections for the coarse solutions using:
  $ eta_p^i = cal(F) u_p^i (T_(p+1)) - cal(C) u_p^i (T_(p+1)), $

  and apply corrections sequentially:
  $ u_{p+1}^i (T_(p+1)) = u_p^i (T_(p+1)) + eta_p^i. $

+ *Iterate*

  Repeat the process for updated initial values until convergence, e.g.:
  $ |u_p^i - u_p^{i-1}| < epsilon #h(11pt) forall p <= N. $

In addition to parallelizing, part of the magic of the Parareal algorithm lies in solving each subproblem not once, but twice with different solves or _propagators_.  The next step in the process is to choose _coarse_, and _fine_. It should be noted that this coarse propagator does not need to be the same as the coarse propagator that was chosen in preparing the subproblems.  Possible propagators include the semi-implicit Euler method with a large time step for the corase propagator, and the velocity-verlet method with a small time step for the fine propagator; in order to satisfy energy-conservation, symplectic integrators should be used.  Without loss of generality, let the chosen coarse and fine propagators be denoted $cal(C), cal(F)$, respectively, and the $n_cal(S)$-th data point for propagator $cal(S)$ in the $p$-th subprobem at iteration $i$ be denoted $u_(p n_cal(S))^i$ and defined traditionally by $u_(p n_cal(S))^i = cal(S) u_(p n_cal(S) - 1)^i$, and the solution from propagator $cal(S)$ on subproblem $p$ is the ordered collection of points $cal(S) u_p^i = u_(p n_cal(S))^i_(n_cal(S))$.

== GPU Computing

GPUs, with their thousands of cores, allow solving 15,000+ subproblems concurrently, greatly enhancing accuracy compared to CPU parallelism, which typically supports only \~10 cores.

== Distributed Computing

Distributed computing frameworks like MPI enable computations across multiple machines, allowing all wave numbers to be solved simultaneously, scaling efficiently to clusters and supercomputers.

= Results

== Particle Production

= Discussion

== Physical Implications

== Numerical Analysis

=== Error

=== Convergence

=== Stability

== Algorithm Analysis

=== Time Complexity

=== Space Complexity

== Benchmarks

= Conclusion

- Equations of motion can now benefit from parallel solvers.

- Certain problems are well-suited to a divide-and-conquer approach.
- Problems with "doubly parallel" characteristics can leverage both local and distributed parallelism, achieving significant computational efficiency.
- These advancements pave the way for modeling acoustics in expanding volumes.

#pagebreak()
#bibliography(
  "bib.bib",
  full: true,
  style: "american-physics-society"
)