#import "@preview/lovelace:0.3.0": *

#let title1 = "Scalable Parallel-in-Time Integration for Equations of Motion"
#let title2 = "Particle Production in Analog Cosmology"
#let title_header = "Scalable PinT Integration for Equations of Motion"
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
      [#emph(smallcaps(title_header)) #h(1fr) #emph(smallcaps(lastSection.body)) #line(length: 100%)]
    }
  }
)
#set par(justify: true, leading: 1em, spacing: 2em) // "leading" == "line spacing"
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
  - Traditional Methods in evolving Equations of Motion
  - Def don't use Runge-Kutta methods
  - Symplectic Euler
  - Velocity Verlet
  - etc.
- PDEs
  - Method of Lines
  - Method of Relaxation

One of the most important algorithms used in evolving equations of motion is the velocity Verlet method.

// == Analog Cosmology

// Directly measuring the properties of the universe just after the Big Bang is impossible, as that was almost 14 billion years ago.  Even _indirectly_ measuring these properties is extremely difficult via traditional means.  During these brief moments just after the Big Bang, the universe expanded rapidly in a particular way.  During this expansion there were particles popping in and out of existence, each with its own dynamics (e.g. position and momentum).

// What is less difficult is cooling down gases to near absolute-zero (about a billion times colder than empty space).  Gases made of certain atoms or molecules have properties that can be changed to almost any value we want.  Because of this, we can turn our knobs in the lab to make the gas behave in a way that matches a certain mathematical model.

// For some types of gases, we can choose how strongly the particles in the gas interact with each other.  It turns out that we can choose a certain interaction strength so that the mathematical model that describes how the gas behaves *exactly* matches the mathematical model of how particles are produced in the universe in the moments just after the Big Bang!  When this happens, we can call this ultra-cold gas an "analog universe".

// Because of this mathematical equality, we can effectively observe the particles in the moments just after the Big Bang, but in the lab. Moreover, these observations can be made using a tried-and-true system that has been developed and used over the past thirty years@firstBEC.

// Studies have investigated gases with
// - phonons with a temporal frequency that is nonlinearly related to the spatial frequency (dispersion relation) @Nonlinear_dispersion_Lorentz_breaking_1 @Nonlinear_dispersion_Lorentz_breaking_2 @Nonlinear_dispersion_Lorentz_breaking_3

// - analog massive particles @massive_1 @massive_2 @massive_3

// - analog particles with non-zero spin @massive_and_spin_4 @massive_and_spin_5 @massive_and_spin_6 @massive_and_spin_7

// - analog universes with different expansion behavior @sudden_transition_1 @sudden_transition_2 @cyclic_cosmology @Experimental_interaction_strength_1

// - analog universes with non-zero background velocity @background_velocity_1 @background_velocity_2 @background_velocity_3 @background_velocity_4 @background_velocity_5

// - promising experimental realizations @Experimental_candidate_1 @Experimental_candidate_2 @Experimental_interaction_strength_1 @Experimental_interaction_strength_2

// Computationally, simulations have had to investigate analog universes of reduced dimension due to the unreasonable time it takes to simulate full-dimensional systems without using high-performance computing.  These simulations have been deemed accurate enough as it is proposed that a full-dimensional simulation would yield qualitatively similar results.  In order to be confident in the level of accuracy of the reduced-dimensional simulations, those results need to be compared to those of a full-dimensional simulation.  This will not only allow a quantification of the error in the reduced-dimensional simulation, but also a measure of the error-to-resource efficiency of a full-dimensional simulation.

// Future insight into these analog systems and the fundamental properties of the early universe require computational support.  A readily-usable computational model will not only allow theoretical investigations to make predictions, but also allow experimental research to have a guide on where to go next and have something with which to compare.  The availability of this work is paramount to more efficient and more physically-accurate insight into our universe.

// I choose a gas with linear dispersion, analog massless and spin-0 particles, an analog universe undergoing a de Sitter expansion with zero background velocity.  The de Sitter spacetime is chosen because of its significance to modern cosmology and previously predicted particle production (as done by Hawking) @de_Sitter_inhomogeneities @de_Sitter_particle_production_1 @de_Sitter_particle_production_2. Particle production will be calculated with standard methods @particle_production_1 @particle_production_2.  The numerical parameters chosen in this study also follow from previous studies @parameters.  Computational implementations will be done using high-performance methods.

// === BEC Analogs of FLRW Cosmologies
// The gas as is outlined is a ground-state Bose-Einstein condensate (BEC) without thermal or quantum fluctuations. The dynamics of the BEC are described by the Gross-Pitaevskii equation (GPE) under a Bogoliubov mean-field approximation (also known as the _nonlinear Schr\u{00F6}dinger equation),_

// $ i planck.reduce diff_t psi (t, harpoon(x)) = [-planck.reduce^2 / (2 m) nabla^2 + V_"ext" (x) + U |psi(t, harpoon(x))|^2] psi(t, harpoon(x)). $ <GPE>

// The wave function $psi$ can be expanded using a linearized Madelung density-phase representation

// $ psi(t, harpoon(x)) = sqrt(n_0 + Delta n(t, harpoon(x))) e^(i (theta_0 + Delta theta(t, harpoon(x))), $ <Madelung>

// where $n_0 + Delta n(t, harpoon(x))$ and $theta_0 + Delta theta(t, harpoon(x))$ are the linearized forms of the real density and phase fields, respectively.  Furthermore, $Delta n(t, harpoon(x))$ and $Delta theta(t, harpoon(x))$ are the density and phase perturbations, respectively.

// With the Madelung representation defined in @Madelung, the GPE in @GPE becomes @Jain

// $ 1 / sqrt(-g) diff_mu [sqrt(-g) g^(mu nu) diff_nu Delta theta] = 0, $ <KG>

// where 

// $ g_(mu nu) = (n_0 / c)^(2 / (d - 1)) mat(
//         -c^2 , dots, 0;
//         dots.v, dots.down , dots.v;
//         0, dots , delta_(i j)
// )
// . $ <metric>

// @metric can be interpreted as the covariant metric tensor (with determinant $g$) describing an analog, spatially flat, Friedmann-Lemaître-Robertson-Walker universe, $c$ is the speed of sound in the condensate, and $d$ is the number of spatial dimensions.  @KG describes both the phase-perturbations $Delta theta$ of oscillations with low spatial frequency (i.e. low momentum phonons) in the BEC and also the dynamics of a quantum field that produces massless, spin-0 particles.

// === Variable Speed of Sound and Inflation

// The time dependence of the system is completely captured in the speed of sound by 

// $ c(t)^2 = U(t) n_0 / m = 4 pi planck.reduce ^2 / m^2 n_0 ell(t), $ <speed>

// with atoms of mass $m$, scattering length $ell(t)$, and number density $n_0$.  With the dimensionless scaling function $a(t)$, the interaction strength $U(t)$ (or equivalently the scattering length) has time dependence defined by 

// $ U(t) equiv U_0 a(t), $

// where $U_0 = U(t_0)$ for an initial time $t_0$.  Then @speed becomes 

// $ c(t) = c_0 sqrt(a(t)). $

// This time dependence of the speed of sound and interaction strength allows us to draw another analogy.  If the speed of sound decreases with time, it would appear as if the space between the source and the observer were increasing.  Similarly, if the speed of sound increases with time, it would appear as if the space between the source and observer is decreasing. With this in mind, if the interaction strength between atoms $U(t)$ decreases with $t$, the analog universe is expanding, and if $U(t)$ increases, the analog universe is contracting.

// === The Field Equation

// With the scaling function, @KG becomes #footnote[$(dot(a)(t)) / a(t)$ is the Hubble parameter for an expanding universe with scaling parameter $a(t)$.]

// $ #text[2D Field Equation:] diff^2 Delta theta - 3/2 (dot(a)(t)) / a(t) diff_t Delta theta - c_0^2 a(t) nabla^2 Delta theta = 0 $ <fieldEquation2D>
// $ #text[3D Field Equation:] diff^2 Delta theta - (dot(a)(t)) / a(t) diff_t Delta theta - c_0^2 a(t) nabla^2 Delta theta = 0 $ <fieldEquation3D>

// These equations only differ in the constant coefficient to the first derivative i.e. the dissipative term.  If we consider the #text(style:"italic", [conformal time]) $eta$ defined by $d eta = sqrt(a(t)) d t$, the two-dimensional field equation (@fieldEquation2D) becomes

// $ diff_eta^2 Delta theta - 1 / 2 (dot(a)(eta)) / a(eta) diff_eta Delta theta - c_0^2 nabla^2 Delta theta = 0. $ <fieldEquationConformal>

// @fieldEquationConformal governs the dynamics of oscillations in the BEC for a time-dependent speed of sound, and the behavior of the massless, spin-0 particles in an expanding universe.

// === Phononic & Free Particle Modes

// The phase $Delta theta(t, harpoon(x))$ and density $Delta n(t, harpoon(x))$ perturbation fields can be expanded in a Fourier plane-wave amplitude representation as 

// $ Delta theta(t, harpoon(x)) = 1 / sqrt(V) sum_harpoon(k) e^(i harpoon(k) dot.c harpoon(x)) tilde(theta)_harpoon(k)(t) hat(b)_harpoon(k)(t) + e^(-i harpoon(k) dot.c harpoon(x)) tilde(theta)_harpoon(k)^*(t) hat(b)_harpoon(k)^dagger (t) $ <FourierExpansionPhase>

// $ Delta n(t, harpoon(x)) = 1 / sqrt(V) sum_harpoon(k) e^(i harpoon(k) dot.c harpoon(x)) tilde(n)_harpoon(k)(t) hat(b)_harpoon(k)(t) + e^(-i harpoon(k) dot.c harpoon(x)) tilde(n)_harpoon(k)^*(t) hat(b)_harpoon(k)^dagger (t) $ <FourierExpansionDensity>

// where $harpoon(k)$ is the wave-vector of the phase and density perturbations, $tilde(theta)$ is the discrete Fourier Transform of the phase perturbation, $hat(b)$ and $hat(b)^dagger$ are the annhilation and creation operators, respectively.  From this, there arises two domains to consider#footnote[These domains can also be described as "acoustic" and "Bogoliubov", respectively.]: phononic quasiparticles with linear dispersion, and free-particle-like quasiparticles with quadratic dispersion.

// The boundary between phononic and free-particle-like quasiparticles is described by the critical wave-number $k_c$.  The critical wave-number $k_c$ is defined @Jain in terms of the healing length of the BEC $xi$, where

// $ xi(t) = planck.reduce / (sqrt(2) m c) = xi_0 / sqrt(a(t)), $ <healing>

// $ k_c (t) = 1 / xi(t) = sqrt(a(t)) / xi_0 $ <critical>

// Wave-vectors $harpoon(k)$ with wave-number $k = ||harpoon(k)||$ such that $k << k_c$ are called _phononic_#footnote[Phononic quasiparticles have linear dispersion $omega = c k$ characterized by neglecting quantum pressure.].  Likewise, those with $k >> k_c$ are called #text(style: "italic")[free-particle-like]#footnote[Free-particle-like quasiparticles have quadratic dispersion characterized by $omega_k (t)^2 = k^2 / (2 m) ((planck.reduce^2 k^2) / (2 m) + 2 U(t) n_0)$ characteried by including quantum-pressure].

// For phononic quasiparticles, the analog between a BEC and an inflationary cosmology is exact.  Including free-particle-like quasiparticles forces the analog to include "trans-Planckian" effects and analog Lorentz violation@Jain.  For these reasons, this investigation focuses only on phononic quasiparticles; namely wave-vectors $harpoon(k)$ such that $||harpoon(k)|| << k_c$.  Additionally, the free-particle-like regime has nonlinear dispersion which significantly increases the complexity of the field equation@Jain.

// Only considering phononic modes, the two-dimensional field (@fieldEquationConformal) then becomes

// $ diff_eta^2 tilde(theta)_harpoon(k) - 1 / 2 (dot(a)(eta)) / (a(eta)) diff_eta tilde(theta)_harpoon(k) - c_0^2 k^2 tilde(theta)_harpoon(k) = 0. $ <fieldEquationConformalFourier>

// For a de Sitter universe, the scaling function is defined such that $a(t) = e^(-t \/ t_s)$.  Therefore, the field equation for a two-dimensional de Sitter universe is

// $ diff_eta^2 tilde(theta)_harpoon(k) - 1 / eta diff_eta tilde(theta)_harpoon(k) + c_0^2 k^2 tilde(theta)_harpoon(k) = 0, $ <fieldEquationdeSitter>

// === Initial Conditions

// As the phase and density perturbations need to be continuous at $t = 0$ when the expansion begins, the initial conditions i.e. spacetime boundary conditions are defined by this physical conservation.  Therefore

// $ tilde(theta)_harpoon(k)(t = 0) = tilde(theta)_(harpoon(k)0) $ <conditionValue>
// $ diff_t tilde(theta)_harpoon(k)(t = 0) = -U / planck.reduce tilde(n)_(harpoon(k)0) $ <conditionDerivative>

// where the initial derivative of the phase perturbation's Fourier amplitude (@conditionDerivative) is determined by neglecting the quantum pressure@Jain.

// === Particle Production

// The number of particles $N_k (t)$ produced at time $t$ with wave-vector $harpoon(k)$ is described by the equation

// $ N_k(t) = |u_k^("out" *)(t) v_k^("exp" *)(t) - v_k^("out" *) u_k^("exp" *)(t)|^2 $ <particleProduction>

// where

// $ u_k (t) = 1 / (2 sqrt(n_0)) tilde(n)_k (t) + i sqrt(n_0) tilde(theta)_k (t) $ <mixedFourierAmplitudes>
// $ v_k (t) = 1 / (2 sqrt(n_0)) tilde(n)_k (t) - i sqrt(n_0) tilde(theta)_k (t), $

// "out" and "exp" corresponding to regions of spacetime outside of and inside the expansion of the universe.

// To summarize, to calculate the number of particles produced at position $harpoon(x)$ and time $t$ with wave-vector $harpoon(k)$ looks like the following:

// #align(center, [
//   + Solve the field equation (@fieldEquationConformalFourier) for $tilde(theta)_harpoon(k)(t)$
//   + Differentiate $tilde(theta)_harpoon(k)(t)$ to get $tilde(n)_harpoon(k)(t)$ as in equation (@conditionDerivative)
//   + Combine $tilde(theta)_harpoon(k)(t)$ and $tilde(n)_harpoon(k)(t)$ as in equations (@mixedFourierAmplitudes)
//   + Calculate the number of particles at time $t$ with wave-vector $harpoon(k)$ as in @particleProduction
// ]
// )

#pagebreak()
== High-Performance Computing

Some key aspects of high-performance computing (HPC) are:
- the difference between processes and threads
- the difference between a CPU "core" and GPU "core"

=== Multi-threading & GPU Computing
- CPU multithreading
- GPU multithreading & CUDA

#figure(
  caption: [Each thread is assigned an index of the array (`index`) based on its location in its block (`threadIdx.x`), how many threads there are in its block (`blockDim.x`), and the block's location in the grid (`blockIdx.x`). The cells in the image above represent cells of the array to which the labeled thread will write.  Image credit @Harris2017.],
  image(
    alt: "",
    "../../images/cuda_indexing.png"
  )
)

#figure(
  caption: [When there are more cells in the array than there are threads in the GPU, each thread processes multiple array cells. Once each thread is finished writing to its cell, it "jumps over" all the cells that were just written to by all the other threads in all the other blocks, and writes to the next one.  The number of cells the thread "jumps", i.e. the _stride_, is determined by the number of threads in each block (`blockDim.x`) and the number of blocks in each grid (`gridDim.x`).  This is known as _index striding_ and is frequently used in GPU programming to process arrays of arbitrary dimension @Harris2013. Image credit @Singal2021],
  image(
    alt: "",
    "../../images/grid-stride-1.png"
  )
)

#pagebreak()
=== Multi-processing & Distributed Computing
- Message Passing & Remote Call Procedure (RPC)

#pagebreak()
== Parallel-in-Time Integration

There are 3 traditional ways to parallelize the solution of a computational problem: 
CPU parallelization, 
GPU parallelization, 
and Distributed computing.  
While CPU parallelization is more straightforward to implement, GPU parallelization can allow for runtimes to decrease by many orders of magnitudes.
Even lower run times can be achieved by combining either of these parallelization schemes with running them on multiple machines.  This investigation focuses on parallelizing the solution of equations of motion using GPUs and multiple machines.

These approaches can offer massive increases in performance, but only for problems that are well-posed to be parallelized.  Traditionally, initial value problems have been unable to be parallelized due their dependence on causality.  Several methods have been created to overcome this limitation.  These methods include the Parareal algorithm, Multigrid Reduction in Time (MGRIT), Parallel Full Approximation Scheme in Space and Time (PFASST).  This investigation focuses on the Parareal algorithm.

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

// Include roadmap for this section; i.e. explicitly tell the reader what's to come. Like section names
// e.g. This chapter begins with a presentation on the Parareal Algorithm, etc.

#let tmax = 8
#let threads = 8
#ex Consider the motion of a thrown ball just after it leaves the hand over the course of #tmax seconds (of course ignoring air resistance). This is going to be simulated on a machine with #threads available threads.  The root initial value problem for this physical scenario can be modeled by:

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
    [0 "s", #tmax "s"], 
    "time span"
  )
}. $ <eq:root>

#pagebreak()
== The Parareal Algorithm <sec:Parareal>

#v(2em)
#align(right, [_The Parareal Algorithm aimed to solve the problem of physics taking too long to simulate; it didn't._])
#v(2em)

The main idea of the Parareal algorithm (PA) is to break up a single IVP into many smaller IVPs using some low-accuracy solution, solve those in parallel using high-accuracy methods, correct your initial solution using the sub-solutions, then make a new low-accuracy solution based on the corrected data, and repeat this process until the solution doesn't change.  The end result of this procedure is a solution identical to one produced by directly using the high-accuracy method while potentially taking a less time @gander2007.  Because the PA wraps traditional (sequential) solvers, it could be considered a "meta-" or "higher-order" method to solve IVPs.

=== Preparing the subproblems

Let the second-order initial value problem $P$ be defined such that

$ P = {cal(L)(t, u, diff_t u, diff_t^2 u) = f(t), #h(11pt)  u(0) = u_0,  diff_t u(0) = v_0, #h(11pt) [t_0, t_0 + Delta t]}, $ <eq:ivp>

and $D = [t_0, t_0 + Delta t]$ is the closed time interval from $t_0$ to $t_0 + Delta t$. The discretization $N$ of $P$ should be determined by the number of available threads $N_t$ such that $N = m N_t$, for some positive integer $m$.  The discretization should be chosen in this manner for maximum performance and efficiency; if $N = m N_t + r$, and $0 < r < N_t$, each thread will solve a subproblem $m$ times until on the $m+1$ iteration where only $r$ threads would be active while $N_t - r$ threads idle (assuming all threads are synchronized).  This type of optimization is sometimes referred to as "_flooding the threadpool_" to mitigate _thread starvation_ #cn.

With the discretization decided, partition the time domain $D$ into subdomains $D_p$ such that

$ D_p = [t_0 + p / N Delta t, t_0 + (p + 1) / N Delta t] = [t_p, t_(p+1)]. $

Use an fast integration method $cal(G)_0$ (such as the Euler method) to compute initial root solutions ${u_p^0}_p$, ${v_p^0}_p$ defined such that

$ {u_p^0}_p = {u_0^0, u_1^0, u_2^0, dots, u_(N-1)^0} $
$ {v_p^0}_p = {v_0^0, v_1^0, v_2^0, dots, v_(N-1)^0} $

and ${u_p^0, v_p^0} = cal(G)(Delta t, u_(p-1)^0, v_(p-1)^0, diff_t^2 u)$.

Subproblems $P_p$ take the same from as in @eq:ivp (this also means subproblems are themselves, problems), but instead using initial conditions defined by those in the initial root solution.  For example, the subproblem $P_1$ for the second ($p = 1$) subdomain, takes the form

$ P_1 = {cal(L)(t, u, diff_t u, diff_t^2 u) = f(t), #h(11pt)  u(0) = u_1^0,  diff_t u(0) = v_1^0, #h(11pt) [t_p, t_(p + 1)]}. $ <eq:example_ivp>

@alg:prep_subproblems shows the pseudocode of this process for a given IVP and integration algorithm i.e. "propagator", resulting in root solutions and and the collected subproblems.  With these subproblems in hand, the PA continues to its next stage: propagating these problems in parallel.

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

+ There should be #threads subproblems because there are #threads available threads.
+ Create the #threads time sub-domains $[0, 1], [1, 2], ..., [#(tmax - 1), #tmax]$.
+ Use the initial position and velocity to quickly solve the root problem via the Euler method to give a sequence of #tmax total positions $harpoon(r)_p^0$ and a sequence of #tmax total velocities $harpoon(v)_p^0$.
+ Use the calculated positions and velocities as initial positions and velocities to create #tmax subproblems on the associated subdomains following the form

$ P_p = {
  diff_t^2 harpoon(r) = harpoon(g), #h(11pt)
  harpoon(r)(0) = harpoon(r)_p^0 \, #h(5pt)
  harpoon(v)(0) = harpoon(v)_p^0,   #h(11pt)
  [t_p, t_(p + 1)]
}. $ <eq:example_subproblem>

The result of this process is shown in @diag:it_0.

#figure(
  image(
    "../../images/root_solution.png", 
    width: 100%,
    alt: "Plot showing the height of the ball vs time so that each subproblem is a column with its initial position as a blue dot at the start of each subdomain, and its velocity as a blue arrow coming from the respective dot.  The true solution is also shown with the same form but in black."
  ),
  caption: "The motion of a ball flying through the air can be partitioned in time to form several initial value problems, each with its own initial position and velocity (upper, blue) determined by a fast integration method. Compared to the true solution (lower, black), this solution is very inaccurate."
) <diag:it_0>

// #pagebreak()
=== Solving the subproblems

Discretizing the domain and propagating initial values as in the previous section constitutes the application of the _coarse propagator_ $cal(G)$ to the root problem.  Because each of the produced subproblems is independent of the others, each can be accurately solved in parallel using a _fine propagator_ $cal(F)$ to reduce the total runtime by a factor equal to the number of subproblems.  In other words, if applying $cal(F)$ to a single subproblem has a runtime $tau_cal(F)$, then applying $cal(F)$ to the root problem directly has a runtime $N * tau_cal(F)$ because there are $N$ subproblems, whereas applying $cal(F)$ in parallel only results in a runtime $tau_cal(F)$ because each application of $cal(F)$ executes at the same time.

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
    - *INPUT:* Discretized domain `ddom` of length `N`
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

Otherwise, the propagation kernel is no more than a traditional IVP solver as described in @sec:trad_methods, but executed on many different subproblems simultaneously over many threads.  This process is shown algorithmically in @alg:prop_kernel.

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
    + *return*
  ]
) <alg:prop_kernel>

*The Parareal Kernel:* In summary, the parareal kernel (@alg:parareal_kernel) is launched on each thread simultaneously and uses the fine propagator to populate arrays prepared from the domain and initial values of that thread's problem.  The domain is discretized by uniformly stepping from the lower bound of the problem's domain to the upper bound.  The initial values are propagated using a traditional integration method (@diag:disc_prop).  The result of this process is sequences of times, positions, and velocities that solve that thread's problem for different discretizations.

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
      a fine propagator `fine`, discretized domain `ddom`, \
      position sequence `pos_seq`, velocity sequence `vel_seq`
    - *OUTPUT:* Nothing
    + Use `fine` in the discretization kernel to populate to `ddom`
    + Use `fine` in the propagation kernel to populate `pos_seq` and `vel_seq`
    + *return*
  ]
) <alg:parareal_kernel>

#figure(
  image(
    "../../images/parallel_propagation_intermediate.png",
    width: 100%,
    alt: "The same plot as before, but now also with a curve of small, red dots coming from each initial position progressing to the right."
  ),
  // square(width: 40%, [some stuff]),
  caption: [Each thread uses coarse and fine propagators to produce intermediate values (small, red dots) from the initial values (big, blue dots and arrows) of its assigned subproblem.  Velocity data does exist, but is neglected here for visual clarity.]
) <diag:disc_prop>

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

+ Define the fine propagator $cal(F)$ as the Velocity-Verlet method with a discretization of $N_cal(F) = #base^#pf = #Nf$.
+ Prepare arrays
  + Allocate $3 * #threads = #(3 * threads)$ arrays of length #Nf for the fine domains, positions, and velocities.
  + Populate the beginning and end of each domain array with the lower and upper bounds, respectively, of each problem's domain.
  + Populate the beginning of each position array with the initial position of each problem.
  + Populate the beginning of each velocity array with the initial velocity of each problem.
+ Launch the Parareal Kernel with the propagators and prepared arrays
  - *Note:* If there are more problems than threads, the kernel can index stride @Harris2013; more on this in @sec:single_gpu.

=== Solving the root problem <sec:corrections>

Because the root solution has been calculated via an inaccurate method, it can be made more accurate using the results of the fine propagator.  Though the root solution is not corrected only with the results of the fine propagator, but rather by coarsely propagating the root initial values again but adding a corrector determined by a combination of the results of the fine propagator and the previous iteration's root solution.  The main idea of this process is known as _Deferred Corrections_ @Ong2020.

The correction phase, as defined in literature @LIONS2001661, takes the deceptively-simple recursive form

$ u_t^i := underbrace(cal(G)(u_(t-1)^i), "predictor") + underbrace(cal(F)(u_(t-1)^(i-1)) - cal(G)(u_(t-1)^(i-1)), "corrector"), $ <eq:correction>

where $u = harpoon(r), harpoon(v)$ represents either position or velocity of the root problem.  If the coarse propagation terms are collected as $Delta_i cal(G)_t^i := cal(G)_t^i - cal(G)_t^(i-1)$, @eq:correction can be interpreted as _shooting method in time_ @gander2007.  It should also be noted that because the values returned by the coarse propagator are identical in successive iterations i.e. $i -> i+1 arrow.double.long cal(G)(u_(t-1)^(i)) = cal(G)(u_(t-1)^(i-1))$, they can be memoized and not calculated again (see @alg:correction), leading to performance increases at the cost of storage space @cormen2022introduction.

One way to interpret the correction equation is "at face value" as

#quote(block: true)[
  _On the current iteration, use the coarse propagator to recommend #footnote[This terminology is inspired by Giordano & Nakanishi's interpretation of the Gauss-Seidel and Simultaneous Over Relaxation methods in their seminal text on computational physics @giordano2006.] what this value should be.  Then correct it by adding the difference between the fine and coarse predictions from the previous iteration.  Record this sum as the actual value._
]

An alternative interpretation arises from, effectively, "moving the correction to the top of the loop" as 

#quote(block:true)[_
  Use the coarse propagator to traditionally evolve the root problem, but with an offset.  This offset is initially zero.
_]

This interpretation changes "_use the propagator, then correct the value_" to "_correct the propagator, then use the value_".

Thus the overall behavior of @eq:correction could be defined through the explicit recurrence relation

$ 
u_t^i &= cal(G)_t^i (u_(t-1)^i) \
u_0^i &= u(0).
$ <eq:parareal_recurrence>

Here the coarse propagator is effectively parameterized and can vary throughout iterations and times such that 
$cal(G)_t^i (u_(t-1)^i) := cal(G)(u_(t-1)^i) + Delta_t^i$ and

$
Delta_t^i &= cal(F)(u_t^i) - cal(G)(u_t^i) \
Delta_t^0 &= 0.
$ <eq:prop_corrector>

@eq:parareal_recurrence has the same structure of a traditional propagation making it much simpler to understand its behavior.  This understanding is made even easier when considering @eq:prop_corrector as it allows the @eq:parareal_recurrence to also define the original coarse propagation of the root problem.  In other words, the corrected coarse propagator has a correction of zero on the original iteration.  While this interpretation is easier to understand, the result is mechanically identical to @eq:correction.

#figure(
  kind: "algorithm",
  supplement: [Alg],
  caption: [New position and velocity solutions are generated by coarse propagating the previous solution in the current iteration and combining it with the difference between the fine and coarse solutions from the previous iteration.  The new solutions are pushed to a the end of the solution arrays.],
  pseudocode-list(
    numbered-title: smallcaps[New Solution Generator],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* Coarse solver `coarse`, \
      Coarse position array `cpos`, Coarse velocity array `cvel`,\
      Fine position array `fpos`, Fine velocity array `fvel`, \
      Root position array `psol[i-1:i, :]`, Root velocity array `vsol[i-1:i, :]`
    - *OUTPUT:* Nothing
    - \/\/ _evaluated at iteration `i`_
    + `psol[i, 0], vsol[i, 0]` #gets `p0, v0`
    + *for* `t` from 1 to `N-1`
      + `ppred[i, t], vpredl[i, t]` #gets `coarse(psol[i, t-1], vsol[i, t-1])`
      + `psol[i, t]` #gets `ppred[i, t] + fpos[i-1, t] - cpos[i-1, t]`
      + `vsol[i, t]` #gets `vpred[i, t] + fvel[i-1, t] - cvel[i-1, t]`
  ]
) <alg:correction>

*Example:*

+ Have arrays of positions and velocities at each time for the previous and current iteration; the first element of the current iteration's array is the initial value of the problem, while the rest of empty.  Also have arrays of positions and velocities generated from the coarse and fine propagators at each time for the previous iteration.
+ Use the new solution generator algorithm with these arrays and the coarse propagator.
+ The arrays for the position and velocity of the root solution at the current iteration are now populated.

=== Converging the root solution

Finally, as own in @alg:parareal, launch the parareal kernel (@alg:parareal_kernel) to gather the fine solutions for each point in time, and construct the new root solution (@alg:correction) until the root solution stops changing between iterations.  While there are many choices that can serve as valid convergence criteria @gander2007, one of the simplest is:

$ max_(1 <= t <= N-1) |u_t^i - u_t^(i-1)| < epsilon, $ <eq:convergence>

for some threshold $epsilon$.  @eq:convergence determines convergence when every point in the solution changes by less than some amount between iterations.

#figure(
  kind: "algorithm",
  supplement: [Alg],
  caption: [The Parareal Algorithm is composed of looping two steps: finding the fine solutions in parallel, then finding the root solution sequentially.  The loop stops when the root solution stops changing.],
  pseudocode-list(
    numbered-title: smallcaps[The Parareal Algorithm],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* Root problem `P`, Coarse propagator `G`, Fine propagator `F`, Convergence threshold `ep`
    - *OUTPUT:* Discretized domain `ddom`, Root position sequence `pos`, Root velocity sequence `vel`
    + `ddom, pos[0, :], vel[0, :]` #gets Prepare the subproblems via a coarse solution
    + `i` #gets `1`
    + *while* `max(changes)` $>=$ `ep`
      + `fpos[t], fvel[t]` #gets Launch the parareal kernel in parallel with `F, pos[i-1, :], vel[i-1, :]` to get the fine solutions for subproblem `t`
      + `pos[i, :], vel[i, :]` #gets Construct new root solutions with `G`, `pos[i-1, :], vel[i-1, :]`, and `fpos, fvel`
      + `changes` #gets The difference between the current and previous solutions
    + *return* `ddom, pos, vel`
  ]
) <alg:parareal>

\
The magic of the Parareal algorithm lies in its divide-and-conquer approach to solving initial value problems.  The "root" problem is sequentially and inaccurately solved to divide it into smaller problems whose initial values are defined by the solution.  Those problems are simultaneously and accurately solved in parallel.  The root problem is then solved in the same way as before, but at each step, the data is modified by combining the previous accurate and inaccurate solutions.  Finally, the new root solution defines new problems, and the loop continues until the the solution has converged.

#pagebreak()
== The Parareal Algorithm at Scale

The PA as described in @sec:Parareal ignores the details and nuances of implementing it.  The primary goal of this work is to provide two new models for implementation: using the massively parallel architecture of graphics processing units (GPUs), and the scalability of distributed systems. Instances of these implementations are also provided @Chapman_PararealGPU_jl.

The PA as defined in @alg:parareal does not change in it _what_ it does when implemented to use GPUs, but rather _how_ it does.  There are several issues that arise when utilizing general-purpose GPU computing (GPGPU) such as the GPU needing to wait until the CPU tells it to do something, better performance with less precision, and the restriction to using primitive types like "ints" and "floats".  Though, the biggest issue is the need to consider the movement of data between RAM and VRAM, or more generally host memory and device memory; considering unshared memory spaces will be even more important in section @sec:distributed.

The distributed-based implementation focuses on distributing problems across multiple remote machines.  These machines solve their problems simultaneously with the other machines, thus achieving a form of parallelism only limited by the number of accessible machines. These problems could either arise from the coarse propagation of a single root problem, yielding a "problem tree" (@diag:problem_tree) where each machine would create-distribute-collect its own set of problems, or if there are multiple "true root" problems e.g. a system of ODEs.

The GPU- and distribution-based methods can be combined to further parallelize solving an initial value problem.  If each of the machines available to the distributed network has at least one GPU (a single machine can have multiple; more details in @sec:distributed), this implementation will automatically identify, manage, and use all of them.  Thus these methods can be composed to provide a scalable model of parallel-in-time integration for equations of motion.

#figure(
  // replace with diagram of problem tree
  // image(
  //   "",
  //   alt: 
  // )
  rect(width: 100%, height: 33%, [#v(1fr) recursive problem distribution and partition tree #v(1fr)]),
  caption: "The problems can be distributed providing a recursively parallelized solution."
) <diag:problem_tree>

// - Distribute problems over multiple processes/devices
//   - Preparing the Cluster
//     - Currently only works for an ssh-cluster i.e. a collection of machines that can all be accessed via ssh from the head node
//     - A "remote node" could also be a single process on a single machine, the differences are straightforward
//     - Given a head node and a collection of remote nodes
//     + Spawn a worker, or "sub-manager", process on each remote node
//     + Each sub-manager identifies how many devices are available to the node, and send that information back to the manager process
//     + The manager process spawns a worker process on the appropriate node for each device on that node
//     + Each process acquires a device
//   + For each problem:
//     + Send it to a process
//     + Execute the parareal algorithm on that problem using the assigned device
//     + Send the result to the manager process to be used in corrections

=== The Parareal Algorithm on the GPU <sec:single_gpu>

The GPU-based implementation focuses on three ideas. The first is utilizing the massively-parallel architecture of a GPU to _simultaneously_ use orders-of-magnitude more threads than what would be possible with a CPU.  The second is considering the movement of data between the host memory (RAM) and the device memory (VRAM). And the last is needing to use primitive data-types.  Otherwise, the underlying algorithm is no different than what is presented in @sec:Parareal.

The PA (@alg:parareal) is only limited by the number of threads at its disposal.  When the number of threads is greater than the number of cores, the processor needs to switch thread contexts in order to balance the evolution of each thread.  On a CPU, this context switching is very costly and can lead to drastic decreases in performance @stallings2011operating @Li2007.  On a GPU however, switching thread-contexts is nearly free @cook2012cuda, allowing there to be _many_ more threads than processors without sacrificing efficiency.  So, it is very beneficial to execute the PA on hardware that not only can efficiently handle many threads, but also have them running at the same time.

All relevant data is first allocated and pre-populated by the CPU on the host.  Then the CPU copies that data to the device. Then the CPU tells the GPU to execute the parareal kernel on its copy of the data, producing solution data. The CPU then copies the solution data from the device to the host and recreates the problems.  The transfer of data (and the CPU launching the kernel on the GPU) between the host and the device serves as the main performance bottleneck in this process. @cook2012cuda Dynamic parallelism can be used to launch kernels directly from the GPU, thus circumventing the performance drawbacks of host-device communication @cook2012cuda.

GPUs can only process primitive types of data such as integers, floats, booleans, and other "bits-types".  This precludes collecting the problem and solution data in more intuitive forms like one would do when representing them mathematically.  In other words, whereas a CPU is happy to handle several boxes each with its own set of elements e.g. domain, acceleration, initial position, and initial velocity, GPUs need this same underlying data to be collected such that all domains are in one box, all acceleration functions are in another box, all initial positions are another, and initial velocities in another.  These "boxes" take the form of arrays.  It is for this reason, the PA as described in @sec:Parareal uses its data as arrays.

So, why is the PA well-suited to be implemented to use GPUs?  Because the data is only composed of numbers, it can be simply represented in a GPU-friendly array structure.  The massive number of cores on a GPU can simultaneously process these arrays with a much lower cost of switching between threads and problems.  And finally, the solution data can be easily copied back to the host.  This process is shown in @alg:parareal_gpu and @diag:gpu_propagation.

#figure(
  kind: "algorithm",
  supplement: [Alg],
  caption: [The Parareal Algorithm is composed of looping two steps: finding the fine solutions in parallel, then finding the root solution sequentially.  The loop stops when the root solution stops changing.],
  pseudocode-list(
    numbered-title: smallcaps[The GPU-Based Parareal Algorithm],
    booktabs: true, 
    hooks: 0.5em
  )[
    - *INPUT:* Root problem `P`, Coarse propagator `G`, Fine propagator `F`, Convergence threshold `ep`
    - *OUTPUT:* Discretized domain `ddom`, Root position sequence `pos`, Root velocity sequence `vel`
    + `i` #gets `0`
    + `ddom, pos[i, :], vel[i, :]` #gets On the host, prepare the subproblems via a coarse solution
    + *while* `max(changes)` $>=$ `ep`
      + `i += 1`
      - \/\/ _fine propagate on the device_
      + `posd[i-1, :], veld[i-1, :]` #gets Copy `F, pos[i-1, :], vel[i-1, :]` to the device
      + `fposd[t], fveld[t]` #gets Launch the parareal kernel to get the fine solutions for subproblem `t`
      + `fpos, fvel` #gets Copy the fine solutions `fposd, fveld` to the host
      - \/\/ _coarse propagate on the host_
      + `pos[i, :], vel[i, :]` #gets Construct new root solutions with `G`, `pos[i-1, :], vel[i-1, :], fpos, fvel`
      + `changes` #gets The difference between the current and previous solutions
    + *return* `ddom, pos, vel`
  ]
) <alg:parareal_gpu>

#figure(
  caption: [Sequential solutions (top in blue) are sent to the GPU to be finely-propagated (mid in red) in parallel; true solutions (bottom in black) are shown for comparison.],
  image(
    width: 91%,
    alt: "",
    "../../images/parallel_propagation_gpu.png"
  )
) <diag:gpu_propagation>

=== The Parareal Algorithm on Multiple GPUs <sec:distributed>

- How did I glue GPU and Distributed computing together with the Parareal algorithm to make it scalable?
  - GPU Computing: solve each subproblem on a each gpu core
    - make stuff into arrays
    - thread indexing blocks streaming multiprocessors
  - Distributed Computing: solve each root problem on each node
    - "Just add another machine"
    - Automatically determine number of devices on each node
    - Sharing data across processes

#figure(
  image("../../images/cluster_topology.png"),
  caption: [A representative cluster topology.]
) <img:cluster_topology>

#pagebreak()
= Analysis

== Numerical Analysis

- use the pendulum i.e. the simple harmonic oscillator to test numerical analysis properties since we know the analytic solutions and can compare.

=== Convergence

=== Stability

=== Error

== Algorithm Analysis

=== Analysis of Parallel Algorithms

=== Time Complexity

- A detailed analysis of the convergence rates of the PA has been done @gander2007.

=== Space Complexity

== Benchmarks

#pagebreak()
= Particle Production in Analog Cosmologies
- Solve the partial differential equation 
- spectral decomposition
- system of equations $partial_t^2 tilde(theta) - (dot(a) / a) partial_t tilde(theta) - a c^2 k^2 tilde(theta) = 0$ for wavenumber $k <= k_c$

#pagebreak()
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
- use a variable size time discretization algorithm, then base integration of those differences

#pagebreak()
#bibliography(
  "bib.bib",
  // full: true,
  style: "american-physics-society"
)