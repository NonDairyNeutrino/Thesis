#import "@preview/lovelace:0.3.0": *

#let title = "Scalable Parallel-in-Time Integration for Equations of Motion"
#let gets  = sym.arrow.l
#let cn    = text(red)[*CN*] // citation needed
#let us    = h(2pt)          // unit space
#let ex    = [*Example:*]

#set page(
  paper: "us-letter",
  margin: (top: auto, rest: 1in),
  numbering: "1/1",
  header: context {
    let sections = query(
      selector(heading.where(level: 2)).before(here())
    )
    if sections != () {
      let lastSection = sections.last()
      // let number = counter(heading).at(lastSection.location())
      [#emph(smallcaps(title1)) #h(1fr) #emph(smallcaps(lastSection.body)) #line(length: 100%)]
    }
  }
)
#set par(justify: true, leading: 1em) // "leading" == "line spacing"
#set text(font: "New Computer Modern", size: 10pt)
#set enum(numbering: "1.1)", full: true)
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
#v(1fr)
#align(center)[
  #text(size: 15pt)[*#title1:\ #title2*]
  #v(1em)
  Nathaniel Chapman#super[1]\
  #super[1]Department of Computer Science, Central Washington University\
  #datetime.today().display("[month repr:long] [day], [year]")
]

#v(1em)
#align(center)[
  #set par(justify: false)
  *Abstract*\
  Simulating time-dependent physics has traditionally been constrained to using sequential algorithms, thus not benefiting from advances in parallel computing.
  Parallel-in-time integration attempts to address this limitation with methods such as the Parareal algorithm.
  As the performance of the Parareal algorithm scales with the number of processors, it is well-suited to use the massively-parallel nature of graphics processing units.
  Additional performance gains are seen when the physics is wave-like, as using a spectral method allows for each node in a distributed system to evaluate the Parareal algorithm.
  Particle production in different cosmologies is used to highlight the performance gains from these methods.
]
#v(1fr)
#pagebreak()

#v(1fr)
#align(right, [_
  This work is dedicated to\
  my friends for sharing laughs and rants,\
  Mr. Chris Lacey for making physics phun,\
  Dr. Brandon Peden for showing me how to be a physicist,\
  and Dr. Andy Piacsek for making sure I finish this damn thing.
_])
#v(1fr)
#pagebreak()

// TABLE OF CONTENTS
#outline(indent: auto)
#pagebreak()

= Introduction

#pagebreak()

= Background

#pagebreak()
== Equations of Motion

According to classical mechanics, the motion for any and every object in the universe can be determined for all time using only its current position, current velocity, and the forces acting on it @Landau1976Mechanics .

=== Differential Equations
- Ordinary Differential Equations (ODE)
- Systems of ODEs e.g. N-Body
  - uncoupled
  - coupled
- Partial Differential Equations (PDE) e.g. wave equation

=== Traditional Numerical Methods <sec:trad_methods>
- ODEs
  - Predictor-Corrector Methods
    - The PA is not the first of its kind to follow this "predict-correct-loop" structure.  In fact, there is a whole class of integration algorithms known as _predictor-corrector_ methods.
    - Hartree-Fock Method (i.e. Self-Consistent Field Theory) is similarly iterative to the PA but iterations are done to minimize energy according to the variational principle of quantum mechanics.
  - Symplectic Integration
  - Traditional Methods in evoling Equations of Motion
  - Def don't use Runge-Kutta methods
  - Symplectic Euler
  - Velocity Verlet
  - etc.
- PDEs
  - Method of Lines
  - Method of Relaxation

One of the most important algorithms used in evolving equations of motion is the velocity Verlet method.

== Analog Cosmology

Directly measuring the properties of the universe just after the Big Bang is impossible, as that was almost 14 billion years ago.  Even _indirectly_ measuring these properties is extremely difficult via traditional means.  During these brief moments just after the Big Bang, the universe expanded rapidly in a particular way.  During this expansion there were particles popping in and out of existence, each with its own dynamics (e.g. position and momentum).

What is less difficult is cooling down gases to near absolute-zero (about a billion times colder than empty space).  Gases made of certain atoms or molecules have properties that can be changed to almost any value we want.  Because of this, we can turn our knobs in the lab to make the gas behave in a way that matches a certain mathematical model.

For some types of gases, we can choose how strongly the particles in the gas interact with each other.  It turns out that we can choose a certain interaction strength so that the mathematical model that describes how the gas behaves *exactly* matches the mathematical model of how particles are produced in the universe in the moments just after the Big Bang!  When this happens, we can call this ultra-cold gas an "analog universe".

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

For phononic quasiparticles, the analog between a BEC and an inflationary cosmology is exact.  Including free-particle-like quasiparticles forces the analog to include "trans-Planckian" effects and analog Lorentz violation@Jain.  For these reasons, this investigation focuses only on phononic quasiparticles; namely wave-vectors $harpoon(k)$ such that $||harpoon(k)|| << k_c$.  Additionally, the free-particle-like regime has nonlinear dispersion which significantly increases the complexity of the field equation@Jain.

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

#align(center, [
  + Solve the field equation (@fieldEquationConformalFourier) for $tilde(theta)_harpoon(k)(t)$
  + Differentiate $tilde(theta)_harpoon(k)(t)$ to get $tilde(n)_harpoon(k)(t)$ as in equation (@conditionDerivative)
  + Combine $tilde(theta)_harpoon(k)(t)$ and $tilde(n)_harpoon(k)(t)$ as in equations (@mixedFourierAmplitudes)
  + Calculate the number of particles at time $t$ with wave-vector $harpoon(k)$ as in @particleProduction
]
)

#pagebreak()
== High-Performance Computing

Some key aspects of high-performance computing (HPC) are:
=== Multi-threading & GPU Computing
=== Multi-processing & Distributed Computing

#pagebreak()
== Parallel-in-Time Integration

There are 3 traditional ways to parallelize the solution of a computational problem: 
CPU parallelization, 
GPU parallelization, 
and Distributed computing.  
While CPU parallelization is more straightforward to implement, GPU parallelization can allow for runtimes to decrease by many orders of magnitudes.
Even lower run times can be achieved by combining either of these parallization schemes with running them on multiple machines.  This investigation focuses on parallelizing the solution of equations of motion using GPUs and multiple machines.

These approaches can offer massive increases in performance, but only for problems that are well-posed to be parallelized.  Traditionally, initial value problems have been unable to be parallelized due their dependance on causality.  Several methods have been created to overcome this limitation.  These methods include the Parareal algorithm, Multigrid Reduction in Time (MGRIT), Parallel Full Approximtaion Scheme in Space and Time (PFASST).  This investigation focuses on the Parareal algorithm.

Parareal
- The Parareal method has mostly been applied to first-order ordinary differential equations.
- Part of the novelty of this work is that it focuses on building support for second-order ODES

#pagebreak()
= Methods

Simulating physical processes has traditionally been done sequentially; even during the modern age of hardware supporting parallel execution, using computers to calculate the evolution of physical phenomena has been sequential.  Why haven't scientists just started doing things in parallel? Because of that pesky thing call _causality_; _the ball must go up before it can come down_.  Because of this temporal dependence (spatial dependence has had its own workarounds such as the Barnes-Hut algorithm @Barnes1986 @Hamada2009), simulation of large-time-scale physics has thus taken a long time to execute.  The Parareal algorithm (PA), and other parallel-in-time integration algorithms, have been developed in the last few decades #cn to specifically address this issue.  
// These paragraphs should be squished together, after the above gets trimmed down
Many details and variations of the Parareal algorithm have been investigated to find and address issues such as stability #cn, convergence rates #cn, application to higher-order differential equations #cn.  The main goal of this investigation is to contribute another variation: an implementation of the Parareal algorithm using methods from high-performance computing.

Before the PA can be implemented using these high-performance methods, the algorithm must be decomposed into its central components.  The Parareal algorithm begins by partitioning a single IVP into several IVPs on smaller domains via an initial, inaccurate, "root" solution.  Then each of the "subproblems" are solved using a sequential, accurate method on different threads at the same time.  The final data for each of the subsolutions is then combined with the respective data of the root solution to yield a more accurate (i.e. "corrected") root solution.  This new root solution is then used to repeat the process until convergence.

The interpretation of the PA in terms of these recursive subproblems makes the algorithm _almost_ embarrassingly parallel; the corrections to the root solution need to be done sequentially.  In addition to this structure, the algorithms being evaluated in parallel manifestly depend on simple arithmetic; because of this simplicity, the PA is well-suited to be evaluated on the GPU.  Likewise, distributed methods can be combined with GPU evaluation for further parallelization for either a single model (taking advantaged of the recursive nature of the PA) or a system of models.

#ex Consider the motion of a thrown ball just after it leaves the hand over the course of 10 seconds (of course ignoring air resistance). This is going to be simulated on a machine with 10 available threads.  The root initial value problem for this physical scenario can be modeled by:

$ P = {
  underbrace(
    diff_t^2 harpoon(r) = harpoon(g) , 
    "Acceleration"
  ), #h(11pt)  
  underbrace(
    harpoon(r)(0) = harpoon(r)_0 \, #h(5pt) 
    harpoon(v)(0) = harpoon(v)_0, 
    "Initial values"
  ), #h(11pt) 
  underbrace(
    [0 "s", 10 "s"], 
    "time span"
  )
}. $ <ex_eq>

#pagebreak()
== The Parareal Algorithm

#v(2em)
#align(right, [_The Parareal Algorithm aimed to solve the problem of physics taking too long to simulate; it didn't._])
#v(2em)

The main idea of the Parareal algorithm (PA) is to break up a single IVP into many smaller IVPs using some low-accuracy solution, solve those in parallel using high-accuracy methods, correct your initial solution using the sub-solutions, then make a new low-accuracy solution based on the corrected data, and repeat this process until the solution doesn't change.  The end result of this procedure is a solution identical to one produced by directly using the high-accuracy method #cn while taking a less time.  Because the PA wraps traditional (sequential) solvers, it could be considered a "meta-" or "higher-order" method to solve IVPs.

=== Subproblem Preparation

Let the second-order initial value problem $P$ be defined such that

$ P = {cal(L)(t, u, diff_t u, diff_t^2 u) = f(t), #h(11pt)  u(0) = u_0,  diff_t u(0) = v_0, #h(11pt) [t_0, t_0 + Delta t]}, $ <eq:ivp>

and $D = [t_0, t_0 + Delta t]$ is the closed time interval from $t_0$ to $t_0 + Delta t$. The discretization $N$ of $P$ should be determined by the number of available threads $N_t$ such that $N = m N_t$, for some positive integer $m$.  The discretization should be chosen in this manner for maximum performance and efficiency; if $N = m N_t + r$, and $0 < r < N_t$, each thread will solve a subproblem $m$ times until on the $m+1$ iteration where only $r$ threads would be active while $N_t - r$ threads idle (assuming all threads are synchronized).  This type of optimization is sometimes referred to as "_flooding the threadpool_" to mitigate _thread starvation_ #cn.

With the discretization decided, partition the time domain $D$ into subdomains $D_p$ such that

$ D_p = [t_0 + p / N Delta t, t_0 + (p + 1) / N Delta t] = [t_p, t_(p+1)]. $

Use an fast integration method $cal(C)_0$ (such as the Euler method) to compute initial root solutions ${u_p^0}_p$, ${v_p^0}_p$ defined such that

$ {u_p^0}_p = {u_0^0, u_1^0, u_2^0, dots, u_(N-1)^0} $
$ {v_p^0}_p = {v_0^0, v_1^0, v_2^0, dots, v_(N-1)^0} $

and ${u_p^0, v_p^0} = cal(C)_0(Delta t, u_(p-1)^0, v_(p-1)^0, diff_t^2 u)$.

Subproblems $P_p$ take the same from as in @eq:ivp, but instead using initial conditions defined by those in the initial root solution.  For example, the subproblem $P_1$ for the second ($p = 1$) subdomain, takes the form

$ P_1 = {cal(L)(t, u, diff_t u, diff_t^2 u) = f(t), #h(11pt)  u(0) = u_1^0,  diff_t u(0) = v_1^0, #h(11pt) [t_p, t_(p + 1)]}. $ <eq:example_ivp>

@alg:prep_subproblems shows the pseudocode of this process for a given IVP and integration algorithm i.e. "propagator", resulting in root solutions and and the collected subproblems.  With these subproblems in hand, the PA continues to its next stage: propagating these problems in parallel.

#pagebreak()
#figure(
  kind: "algorithm",
  supplement: [Alg],
  caption: [Prepare the subproblems],
  pseudocode-list(
    numbered-title: smallcaps[Prepare the subproblems],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* Second order initial value problem `P`, Coarse solver `C`
    - *OUTPUT:* Solution for `P` made from `pos_seq` and `vel_seq`, and array of subproblems `subproblems`
    - \/\/ _choose discretization_
    + `N` #gets number of subproblems \/\/ _e.g. multiple of \# of computer cores_
    - \/\/ _partition the domain of P into N subdomains e.g. [a, b] -> {[a, c], [c, b]}_
    + `subdomains` #gets `partition(P.domain)`
    - \/\/ _use coarse solver to get positions and velocities for the root problem_
    + `pos_seq`, `vel_seq` #gets `propagate(P, C)`
    - \/\/ _create subproblems_
    + *for* `i` from 1 to `N - 1`
      + `subdomain` #gets `i`-th domain partition `subdomains[i]`
      + `pos0` #gets initial position for `i`-th subproblem `pos_seq[i]`
      + `vel0` #gets initial velocity for `i`-th subproblem `vel_seq[i]`
      + `subproblems[i]` #gets ivp on `subdomain` with initial values `pos0` and `vel0` for acceleration `P.acc`
    + *return* Solution for root problem with `pos_seq` and `vel_seq`, and array of subproblems `subproblems`
  ]
) <alg:prep_subproblems>
\
#ex Given the example IVP (@eq:example_ivp) and the available threads,

+ There should be 10 subproblems because there are 10 available threads.
+ Create the 10 time sub-domains $[0, 1], [1, 2], ..., [9, 10]$.
+ Use the initial position and velocity to quickly solve the root problem via the Euler method to give a sequence of 10 positions $harpoon(r)_p^0$ and a sequence of 10 velocities $harpoon(v)_p^0$.
+ Use the calculated positions and velocities as initial positions and velocities to create 10 subproblems on the associated subdomains following the form

$ P_p = {
  diff_t^2 harpoon(r) = harpoon(g), #h(11pt)
  harpoon(r)(0) = harpoon(r)_p^0 \, #h(5pt)
  harpoon(v)(0) = harpoon(v)_p^0,   #h(11pt)
  [0 "s", 10 "s"]
}. $ <eq:example_subproblem>

The result of this process is shown in @diag:it_0.

#figure(
  image(
    "images/root_solution.png", 
    width: 100%,
    alt: "Plot showing the height of the ball vs time so that each subproblem is a column with its initial position as a blue dot at the start of each subdomain, and its velocity as a blue arrow coming from the respective dot.  The true solution is also shown with the same form but in black."
  ),
  caption: "The motion of a ball flying through the air can be partitioned in time to form several initial value problems, each with its own initial position and velocity (upper, blue) determined by a fast integration method. Compared to the true solution (lower, black), this solution is very inaccurate."
) <diag:it_0>

// #pagebreak()
=== Parallel Discretization & Propagation

Because each of these subproblems is independent of the others, each can be solved in parallel; #lower([@sec:corrections]) addresses recombining their solutions to produce a larger solution to the root problem.  Though the subproblems are solved in parallel not once, but twice using a _fine propagator_ $cal(F)$, and again using a _coarse propagator_ $cal(C)$.  It should be noted that this coarse propagator $cal(C)$ does not need to be the same as what was used $cal(C)_0$ to construct the initial root solution.

In general, a *propagator* $cal(P)$ is defined by two key components: its integration algorithm $I_cal(P)$, and its discretization $N_cal(P)$. More specifically, the propagator $cal(P)$ can be interpreted as a higher-order function mapping integration algorithms and discretizations to functions that, when applied to an IVP, reduce to sequences ${(t, harpoon(r)_t)}_t, {(t, harpoon(v)_t)}_t$ of time-position and time-velocity pairs, respectively; the collection of the sequences is called the *solution* $S_P$ of $P$.  The solution can be interpreted as the set of function-graphs (as defined in @pinter2014book) of $harpoon(r)$ and $harpoon(v)$, and is defined such that

$ cal(P)(I_cal(P), N_cal(P))(P) = {{(t, harpoon(r)_t)}_t, {(t, harpoon(v)_t)}_t} =: S_P. $ <eq:solution>

The application of the propagator to the subproblem is the core, or *kernel*, of the PA. While this description of the kernel is useful for understanding, it does not immediately lead to an algorithm that is well-suited for hardware-agnostic implementation (more details in #lower([@sec:single_gpu]) on #ref(<sec:single_gpu>, form: "page")). To that end, the implementation of the kernel presented here is composed of discretizing the subdomain and propagating the initial values separately.

#pagebreak()
*Discretization:* To avoid performance losses from each kernel allocating memory, each discretization kernel references a specific, pre-allocated, one-dimensional array $delta D$ of length $N_cal(P)$.  In order for the kernel to generate the appropriate samplings of the domain, $delta D$ has its first and last elements pre-populated with the values of the lower and upper bounds of that thread's assigned subproblem such that 

$ delta D = {t_p, [N_cal(P) - 2 "arbitrary elements"], t_(p + 1)}. $

With each kernel accessing this data, it can simply calculate and write the domain samples in-place; this process is shown in @alg:disc_kernel.

#figure(
  kind: "algorithm",
  supplement: [Alg],
  caption: [Each discretized subdomain is calculated by uniformly stepping from the lower bound to the upper bound.  These results are written in-place.],
  pseudocode-list(
    numbered-title: smallcaps[Parallel Discretization Kernel],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* The pre-allocated, pre-populated discretized domain `ddom`\
      of length `N`
    - *OUTPUT:* Nothing
    + `a, b` #gets `(ddom[0], ddom[N-1])`
    + step #gets (`b` - `a`) / 2
    + *for* `i` from 1 to `N - 2`
      + `ddom[i]` #gets `a + (i - 1) * step`
    + *return*
  ]
) <alg:disc_kernel>

*Propagation:* Much like the discretization kernel, the propagation kernel avoids memory allocations by using pre-allocated, pre-populated multidimensional arrays to store the position and velocity sequences; the initial values of the position and velocity for that kernel's subproblem are pre-populated as their respective arrays first element taking the form

$ {harpoon(r)_t}_t = {harpoon(r)_(t_p), [N_cal(P) - 1 "arbitrary elements"]} quad {harpoon(v)_t}_t = {harpoon(v)_(t_p), [N_cal(P) - 1 "arbitrary elements"]} $

Otherwise, the propagation kernel is no more than a traditional IVP solver as described in @sec:trad_methods, but executed on many different subproblems simultaneously over many threads.  This process is shown algorithmically in @alg:prop_kernel, and visually in @diag:disc_prop.

#figure(
  kind: "algorithm",
  supplement: [Alg],
  caption: [Each subproblem is solved in parallel using traditional methods.],
  pseudocode-list(
    numbered-title: smallcaps[Parallel Propagation Kernel],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* A solver `solve`, \
      acceleration function `acc`, \
      sequence of `N` position vectors `pos_seq`, \
      sequence of `N` velocity vectors `vel_seq`
    - *OUTPUT:* Nothing
    + *for* `i` from 2 to `N - 1`
      + `old_pos, old_vel` #gets `pos_seq[i - 1], vel_seq[i - 1]`
      + `pos_seq[i], vel_seq[i]` #gets `solve(old_pos, old_vel, acc, step)`
  ]
) <alg:prop_kernel>

*The Parareal Kernel:* In summary, the parareal kernel (@alg:parareal_kernel) is launched on each thread simultaneously and uses the coarse and fine propagators to populate arrays prepared from the domain and initial values of that thread's problem.  The domain is discretized by uniformly stepping from the lower bound of the problem's domain to the upper bound.  The initial values are propagated using a traditional integration method (@diag:disc_prop).  The result of this process is sequences of times, positions, and velocities that solve that thread's problem for different discretizations.

After the parareal kernel has completed, ...

#figure(
  kind: "algorithm",
  supplement: [Alg],
  caption: [Put it all together],
  pseudocode-list(
    numbered-title: smallcaps[The Parareal Kernel],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* 
      A coarse propagator `coarse`, a fine propagator `fine` \
      discretized domain `ddom_coarse`, position sequence `pos_seq_coarse`, velocity sequence `vel_seq_coarse`, \
      discretized domain `ddom_fine`, position sequence `pos_seq_fine`, velocity sequence `vel_seq_fine`
    - *OUTPUT:* Nothing
    - \/\/ _discretization kernel_
    + Use `coarse` to populate `ddom_coarse`
    + Use `fine` to populate to `ddom_fine`
    - \/\/ _propagation kernel_
    + Use `coarse` to populate `pos_seq_coarse` and `vel_seq_coarse`
    + Use `fine` to populate `pos_seq_fine` and `vel_seq_fine`
    + *return*
  ]
) <alg:parareal_kernel>

#figure(
  image(
    "images/parallel_propagation_intermediate.png",
    width: 100%,
    alt: ""
  ),
  // square(width: 40%, [some stuff]),
  caption: [Each thread simultaneously propagates (small, red dots) the initial values (big, blue dots and arrows) of its assigned subproblem.  Velocity data does exist, but is neglected here for visual clarity.]
) <diag:disc_prop>

#pagebreak()
// The solution structure as in @eq:solution is recovered by combining the results of the discretization and propagation kernels according to the algorithm in @alg:solution_constructor.  The separation of the discretization and propagation kernels allows the discretized domain to be only calculated once, while being used in both the solutions for the position and velocity.  Further advantage is taken in the next section.

// #figure(
//   kind: "algorithm",
//   supplement: [Alg],
//   caption: [Solutions are formed from the results of the discretization and propagation kernels.],
//   pseudocode-list(
//     numbered-title: smallcaps[Solution Constructor],
//     booktabs: true, 
//     hooks: 0.5em
//   )[
//     - *INPUT:* Discretization `N`, Discretized domain `ddom`, \
//       Position sequence `pos_seq`, Velocity sequence `vel_seq` \
//       Position solution `pos_sol`, Velocity solution `vel_sol`
//     - *OUTPUT:* Solution `S`
//     + *for* `i` from 0 to `N - 1`
//       + `t, r, v` #gets (`ddom[i], pos_seq[i], vel_seq[i]`)
//       + `pos_sol[i], pos_sol[i]` #gets `((t, r), (t, v))`
//     + `S` #gets `(pos_sol, vel_sol)`
//     + *return* `S`
//   ]
// ) <alg:solution_constructor>

#ex For each of the #threads subproblems described by @eq:example_subproblem, each taking the form

#math.equation(block: true, numbering: none,
$ P_p = {
  diff_t^2 harpoon(r) = harpoon(g), #h(11pt)
  harpoon(r)(0) = harpoon(r)_p^0 \, #h(5pt)
  harpoon(v)(0) = harpoon(v)_p^0,   #h(11pt)
  [t_p, t_(p + 1)]
}. $
)

#let base = 2
#let pc = 2 // power coarse
#let pf = 6 // power fine
#let Nc = calc.pow(base, pc)
#let Nf = calc.pow(base, pf)

+ Choose your propagators
  + Define the coarse propagator $cal(C)$ as the Symplectic-Euler method with a discretization of $N_cal(C) = #base^#pc = #Nc$.
  + Define the fine   propagator $cal(F)$ as the Velocity-Verlet  method with a discretization of $N_cal(F) = #base^#pf = #Nf$.
+ Prepare arrays
  + Allocate 3 \* #threads = #(3 * threads) arrays of length #Nc for the coarse domains, positions, and velocities.
  + Allocate 3 \* #threads = #(3 * threads) arrays of length #Nf for the fine   domains, positions, and velocities.
  + Populate the beginning and end of each domain array with the lower and upper bounds, respectively, of each problem's domain.
  + Populate the beginning of each position array with the initial position of each problem.
  + Populate the beginning of each velocity array with the initial velocity of each problem.
+ Launch the Parareal Kernel with the propagators and prepared arrays
  - *Note:* If there are more subproblems than threads, their assignment can be determined via index striding @Harris2013; more on this in @sec:single_gpu.

=== Corrections <sec:corrections>

Once the subsolutions have been found, only the final data is kept

Compute corrections for the coarse solutions using:
$ eta_p^i = cal(F) u_p^i (T_(p+1)) - cal(C) u_p^i (T_(p+1)), $

and apply corrections sequentially:
$ u_{p+1}^i (T_(p+1)) = u_p^i (T_(p+1)) + eta_p^i. $

=== Iteration & Convergence

  Repeat the process for updated initial values until convergence, e.g.:
  $ |u_p^i - u_p^{i-1}| < epsilon #h(11pt) forall p <= N. $

In addition to parallelizing, part of the magic of the Parareal algorithm lies in solving each subproblem not once, but twice with different solves or *propagators*.  The next step in the process is to choose *coarse*, and *fine*. It should be noted that this coarse propagator does not need to be the same as the coarse propagator that was chosen in preparing the subproblems.  Possible propagators include the semi-implicit Euler method with a large time step for the corase propagator, and the velocity-verlet method with a small time step for the fine propagator; in order to satisfy energy-conservation, symplectic integrators should be used.  Without loss of generality, let the chosen coarse and fine propagators be denoted $cal(C), cal(F)$, respectively, and the $n_cal(S)$-th data point for propagator $cal(S)$ in the $p$-th subprobem at iteration $i$ be denoted $u_(p n_cal(S))^i$ and defined traditionally by $u_(p n_cal(S))^i = cal(S) u_(p n_cal(S) - 1)^i$, and the solution from propagator $cal(S)$ on subproblem $p$ is the ordered collection of points $cal(S) u_p^i = u_(p n_cal(S))^i_(n_cal(S))$.

#pagebreak()
== The Parareal Algorithm at Scale

- Parallelize on the GPU instead of the CPU
  - Port functionality to kernel calls
    - Technical: Instead of objects with properties, it's just the same index for a bunch of different arrays
    - Vibes: Makes logic less understandable comp
  + From the host, launch the Parareal kernel on the device
    + Each core on the device executes the same sequence of instructions (kernel), but uses different thread-local variables such as their thread id, block id, etc.
    + Use traditional and sequential solvers on each core for each subproblem
    + Write the final point to an array
  + Send solution data back to host for sequential correction
  + Host corrects and loops

- Distribute problems over multiple processes/devices
  - Preparing the Cluster
    - Currently only works for an ssh-cluster i.e. a collection of machines that can all be accessed via ssh from the head node
    - A "remote node" could also be a single process on a single machine, the differences are straightforward
    - Given a head node and a collection of remote nodes
    + Spawn a worker, or "sub-manager", process on each remote node
    + Each sub-manager identifies how many devices are available to the node, and send that information back to the manager process
    + The manager process spawns a worker process on the appropriate node for each device on that node
    + Each process acquires a device
  + For each problem:
    + Send it to a process
    + Execute the parareal algorithm on that problem using the assigned device
    + Send the result to the manager process to be used in corrections

#figure(
  image("../../images/cluster_topology.png"),
  caption: [A representative cluster topology.]
) <img:cluster_topology>

=== The Parareal Algorithm on the GPU <sec:single_gpu>

- Execute the parallel propagation on the GPU
  - Requires transforming "regular code" into a "kernel" that's evaluated on every computer core
  - Make solution data an array that is copied to the device which can then just write to the appropriate index
  - Use thread-local variables (e.g. `threadidx.x`, `blockIdx.x`, etc.) to identify the appropriate index
  - "Don't overwrite your neighbor" by index striding.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [GPU kernel to calculate the discretized points in a subdomain in-place],
  pseudocode-list(
    numbered-title: smallcaps[discretize_kernel],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* Sequence of points in the subdomain `dompnts`
    - *OUTPUT:* Nothing
    + `npnts`   #gets number of points in `dompnts`
    + `lb`      #gets lower bound of this subdomain `dompnts[1]`
    + `ub`      #gets upper bound of this subdomain `dompnts[-1]`
    + `step`    #gets (`ub` - `lb`) / `npnts`
    + *for* `i` from 2 to (`npnts` - 1)
      + `dompnts[i]` #gets `lb` + (`i` - 1) \* `step`
  ]
)

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [GPU kernel to propagate solutions in-place],
  pseudocode-list(
    numbered-title: smallcaps[propagate_kernel],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* Solver function `sol`, Acceleration function `acc`, Domain points `dompnts`, Position sequence `pos_seq`, Velocity sequence `vel_seq`
    - *OUTPUT:* Nothing
    + `npnts` #gets number of points in domain `dompnts`
    + *for* `i` from 2 to (`npnts` - 1)
      + `op` #gets old position `pos_seq[i - 1]`
      + `ov` #gets old velocity `vel_seq[i - 1]`
      + `np` #gets new position `pos_seq[i]`
      + `nv` #gets new velocity `vel_seq[i]`
      + `np`, `nv` #gets `solver`(`op`, `ov`, `acc`, `step`) // FIXME: find call to step
  ]
)

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [Main kernel],
  pseudocode-list(
    numbered-title: smallcaps[kernel],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* Solver function `sol`, Acceleration function `acc`, Sequence of sequenes of domain points `dss`, Sequence of sequences of positions `pss`, Sequence of sequences of velocities `vss`
    - *OUTPUT:* Nothing

    + `nsols`   #gets number of subproblems or subdomains

    - \/\/      INDEX STRIDING // make gray to more directly show it's a comment
    + `index`  #gets (block_id - 1) \* block_dim + thread_id
    + `stride` #gets grid_dim \* block_dim
    + *for* `i` from `index` to `nsols` in steps of `stride`

      - \/\/    DISCRETIZE DOMAINS
      + `dompnts` #gets sequence of points in this subdomain `dss[i]`
      + `discretize_kernel`(`dompnts`)

      - \/\/      ALLOCATE SOLUTIONS
      + `pos_seq` #gets sequence of positions for this subproblem `pss[i]`
      + `vel_seq` #gets sequence of velocities for this subproblem `vss[i]`
      + `propagate_kernel`(`sol`, `acc`, `dompnts`, `pos_seq`, `vel_seq`)
  ]
)

#figure(
  image("../../images/parallel_propagation_gpu.png", width: 100%),
  caption: [Sequential solutions (blue) are sent to the GPU to be finely-propagated (red) in parallel; true solutions (black) are shown for comparison.]
)

=== The Parareal Algorithm on Multiple GPUs

- How did I glue GPU and Distributed computing together with the Parareal algorithm to make it scalable?
  - GPU Computing: solve each subproblem on a each gpu core
    - make stuff into arrays
    - thread indexing blocks streaming multiprocessors
  - Distributed Computing: solve each root problem on each node
    - "Just add another machine"
    - Automatically determine number of devices on each node
    - Sharing data across processes

#pagebreak()
= Discussion

== Numerical Analysis

- use the pendulum i.e. the simple harmonic oscillator to test numerical analysis properties since we know the analytic solutions and can compare.

=== Convergence

=== Stability

=== Error

== Algorithm Analysis

=== Analysis of Parallel Algorithms

=== Time Complexity

=== Space Complexity

== Benchmarks

= Particle Production in Analog Cosmologies
- Solve the partial differential equation 
- spectral decomposition
- system of equations $partial_t^2 tilde(theta) - (dot(a) / a) partial_t tilde(theta) - a c^2 k^2 tilde(theta) = 0$ for wavenumber $k <= k_c$

= Conclusion
- Equations of motion can now benefit from parallel solvers.
- Certain problems are well-suited to a divide-and-conquer approach.
- Problems with "doubly parallel" characteristics can leverage both local and distributed parallelism, achieving significant computational efficiency.
- These advancements pave the way for modeling acoustics in expanding volumes.

== Future work
- Krylov enhanced subspaces
- CUDA dynamic parallelism
- Implement with C, Fortran, CUDA, NVSHMEM, MPI
- Make gpu-backend-agnostic with KernelAbstractions.jl
- this physics could be better done with PFASST
- non-dimensionalize everything following @langtangen2016scaling

#pagebreak()
#bibliography(
  "bib.bib",
  full: true,
  style: "american-physics-society"
)