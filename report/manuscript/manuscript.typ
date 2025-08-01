#import "@preview/lovelace:0.3.0": *
#import "@preview/hydra:0.6.1": hydra

#let title1 = "Scalable Parallel-in-Time Integration for Equations of Motion"
#let title2 = "" // "Particle Production in Analog Cosmology"
#let gets  = sym.arrow.l
#let cn    = text(red)[*CN*] // citation needed
#let us    = h(2pt)          // unit space
#let ex    = [*Example:*]

#set document(
  title: [title],
  author: "Nathan Chapman"
)
#set page(
  paper: "us-letter",
  margin: (top: auto, rest: 1in),
  numbering: "i" /* do not change; updated after  */,
  header: context {
    let sections = query(selector(heading.where(level: 1)).before(here()))
    // [#here().position()]
    if sections != () {
      [#emph(hydra(1)) #h(1fr) #emph(hydra(2)) #line(length: 100%)]
    }
  }
)
#set par(justify: true, leading: 0.75em, spacing: 1.5em) // "leading" == "line spacing"
#set text(font: "New Computer Modern", size: 11pt)
#set math.equation(numbering: "(1)", supplement: [Eq.])
#set enum(numbering: "1.1)", full: true)
#set heading(numbering: "1.",)
#show heading: set block(below: 1em)
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#show heading.where(level: 2): it => pagebreak(weak: true) + it
#show outline.entry.where(
    level: 1
  ): it => {
    v(12pt, weak: true)
    strong(it)
  }

// TITLE
#v(1fr)
#align(center)[
  #text(size: 15pt)[*#title1*]
  #v(1em)
  Nathan Chapman#super[1]\
  #super[1]Department of Computer Science, Central Washington University\
  #datetime.today().display("[month repr:long] [day], [year]")
]

#v(1em)
#align(center)[
  #set par(justify: false)
  *Abstract*\
  Physical simulations always need to balance accuracy and run-time.  This work implements the Parareal Algorithm using graphics processing units across a distributed system to accurately simulate time-dependent physics while minimizing runtime.  Several methods are identified that could further improve performance by minimizing latency associated with transferring data between host and device as well as between hosts in the system.  Preliminary benchmarks are provided.
]
#v(1fr)
#pagebreak()

#v(1fr)
#align(right, [_
  This work is made possible thanks to\
  my friends for sharing laughs and rants,\
  Mr. Chris Lacy for making physics phun,\
  Dr. Brandon Peden for showing me how to be a physicist,\
  and Dr. Andy Piacsek for never giving up on me.\ \
  I wouldn't have been able to do it without you.
_])
#v(1fr)
#pagebreak()

// TABLE OF CONTENTS
#outline(indent: auto)

#set page(numbering: "1/1")
#counter(page).update(1)

= Introduction

The idea is simple: calculations take time, and that is bad.
Heuristically, the total time needed for all calculations to finish depends on both the number of calculations needed to be done, and the number of calculations that can finish in some time.
To minimize the total time, either the number of calculations needs to be minimized, the number of calculations per time needs to be maximized, or both.
This work focuses on the latter.

While the speed of computers has increased significantly, the most recent advances have seen diminishing returns in reducing the time needed for a single calculation.
Parallel computing allows multiple calculations to finish in the same amount of time as a single calculation, thus increasing the number of calculations that can occur per time.
For scientific problems concerning both space and time, parallelism has reduced the time needed to the spatial part of the problem, leaving the temporal component to still be done sequentially.
Parallel-in-Time Integration (PinT) allows the dynamics of the problem to be calculated in parallel along with the spatial behavior, thus further reducing the time needed.

Even though PinT allows every dimension of problem to be calculated simultaneously, the speedup factor is still limited by how many calculations can happen simultaneously.
A single central processing unit (CPU), at the time of writing, can execute about ten calculations at the same time.
On the other hand, a single graphics processing unit (GPU) can execute about ten thousand calculations at the same time.
Likewise, multiple machines can be used to distribute calculations among them, which are similar executed simultaneously.
The use of GPUs and distributed systems of machines together offers a foundation on which an arbitrarily large problem could be solved.

It's not uncommon for available hardware to provide more power than what's needed for a problem to only be spatially parallelized.
For example, a simulation of a wave could discretize space to a degree such that any higher resolution would not provide a significant increase in accuracy, and to satisfy the Courant-Friedrichs-Lewy condition (CFL), time must be discretized to a similar degree. Modern high-performance computing (HPC) systems can execute all calculations for all spatial intervals simultaneously while having compute capability left over.
Thus, in order to fully utilize these HPC systems, PinT methods must be not only used, but implemented to take advantage of the resources provided such as GPUs and distributed systems.
That's where this work comes in.

This work focuses on implementing the Parareal algorithm (PA) from PinT to use HPC methods and resources in order to more efficiently simulate the dynamics of physical systems, in particular wave-like motion.
While wave-like motion is the focus of the physics, this implementation and can be used to simulate other types of motion such as molecular dynamics, weather and climate forecasting, plasma dynamics in fusion reactors, or any system that is modeled by an equation of motion.
With this work, computational modeling and simulation can scale not only with the needed accuracy of the problem but also with the performance and availability of hardware.
Overall, HPC resources will be more efficiently utilized, results will be accurate as possible, and most importantly, time will be minimized.

// ROADMAP OF OF CHAPTERS
This work is composed of five parts: an overview of the field of PinT, a presentation of the PA itself, a presentation of how the PA can be implemented to use HPC methods, and analyses on the performance of the implementation.
@sec:background details the landscape in which this project lies including other projects using high-performance implementations of PinT algorithms.
@sec:parareal serves as a review of the PA from PinT in the context of numerically solving equations of motion while also presenting it in such a way that implementing it at scale is a natural extension.
@sec:scale serves as the core of this work describing the details of implementing the PA using high-performance methods.
@sec:analysis provides analysis the performance of the implementation providing benchmarks, identifying sources of and suggesting methods to mitigate latency associated with transferring data, and traditional numerical analysis of results.

@sec:background gives an overview of the most notable methods and approaches used in PinT, how PinT has been used, and some examples of implementations of certain PinT algorithms.  
These notable methods include those based on spectral deferred corrections, multigrid reductions, and multiple-shooting.
PinT has been used for real science ranging from simulating the blood flow in fish to gravitational collapse.
Select implementations include those based on small-scale multiprocessing as well as full-scale supercomputing.

@sec:parareal first offers a review of concepts in computational physics that are fundamental to this work, and details how the PA can be used to simulate motion in parallel.  
@sec:parareal_eom provides baseline knowledge of how initial-value problems model motion, how energy drift can be used to measure the error of a simulated physical system and how symplectic integrators can be used to mitigate this error, and two types of methods of which the PA can be considered an instance.  
@sec:parareal_parareal goes through the PA itself, presenting each key step in a way that makes the extension to using HPC methods intuitive.
While the PA is not a new contribution, the presentation of it in this way is not only new but also key to understanding the details of why it is so well-suited for HPC.

@sec:scale first presents a review of concepts in HPC that are fundamental to this work, and then how the PA can be implemented to take advantage of these HPC concepts.
@sec:scale_hpc focuses on reviewing the concepts of multithreading and how it applies to using GPUs for general-purpose computing, as well as multiprocessing and how it can distribute calculations over multiple machines.
@sec:scale_gpu first identifies how GPUs offer a meaningful increase in performance due to their incredible parallel-processing power and how to "simply move the expensive part to the GPU".  
@sec:scale_distributed details how to construct and use a cluster of computers such that the PA can be executed on GPUs across multiple machines that are possibly not even in the same physical location.

@sec:analysis covers analysis of this implementation.
@sec:analysis_numerical details the numerical effects of discretization on error/energy drift, stability, and convergence.
@sec:analysis_latency describes the influence, issues, and mitigation methods of transferring data between memory spaces.
@sec:analysis_benchmarks addresses the core goal of this work: how this implementation affects the time needed to simulate motion.

= Background <sec:background>

The PA has been one of the most widely studied PinT algorithms @pintorg, but there are several other PinT methods that have garnered attention over the years (as seen in @img:pint_history).
These methods and their uses have used several different implementations ranging from using small-scale, distributed systems to "true HPC" at Lawrence-Livermore National Lab (LLNL).
These methods have also been used in practice for simulating the dynamics of systems from biology to gravitational collapse.
This work aims to add to the field of PinT by building a foundation of using HPC methods for PinT in the scientific computing programming language Julia.

#figure(
  caption: [The number of papers published (shown on the vertical axis) regarding parallel-in-time integration has significantly, and steadily, increased over the past few decades.  It is also worth noting that at the time of writing, the number of papers published this is year is on track to match last year's.   Image credit @pintorg],
  image(
    "images/pint_history.png",
    width: 80%,
    alt: ""
  )
) <img:pint_history>

// ALGORITHMS
While this work focuses on the PA, there are several other notable algorithms that have been developed.
There is of course the PA @parareal_og_2001, but the Parallel Implicit Time-Integrator (PITA) method has been developed as an implicit variation @FarhatEtAl2003.
The Parallel Full Approximation Scheme in Space and Time (PFASST) @EmmettMinion2012 @RuprechtEtAl2013_SC and Revisionist Integral Deferred Correction (RIDC) @ChristliebEtAl2010 are based on the idea of deferred-corrections. 
A sub-class of PinT algorithms is based diagonalizing the time discretization matrix and decoupling an "all-at-once" system into a series of sub-systems @MadayRonquist2008; this type of method is particularly notable because it is well suited for dissipative and hyperbolic problems @GanderEtAl2021.  
On the other end, both the Space-time Multigrid (STMG), which treats the whole space-time domain simultaneously @HortonVandewalle1995, and Space-time concurrent multigrid waveform relaxation (WRMG), which relies on cyclic reduction to run in polylog parallel time with linear serial complexity @LubichOstermann1987 @VandewalleVandeVelde1994 @HortonEtAl1995 @VandewalleHorton1995, are well suited for parabolic partial differential equations.
Finally, the Multigrid Reduction in Time (MGRIT) algorithm has been developed at Lawrence-Livermore National Lab to target hyperbolic problems, computational fluid dynamics, power grids, medical applications, etc. @FriedhoffEtAl2013.

// IMPLEMENTATIONS
These algorithms have been implemented in various languages using different approaches of parallelism, though mostly OpenMP for CPU-based multithreading and MPI for multiprocessing.
The PA has been implemented in Fortran as PararealF90 with versions using MPI and OpenMP @Ruprecht2017_lncs, in Python using MPI @schreiber2016, and in Julia using its native multiprocessing support @masthay2018.
PFASST has been implemented in C++ as PFASST++ @EmmettMinion2012, as well as in Python as pySDC using MPI @Speck_Parallel-in-Time_pySDC_2025 @speck2019.
MGRIT has been implemented in Python as PyMGRIT using MPI @HahneEtAl2020, as well in C as XBraid also using MPI @xbraid-package.
RIDC has been implemented in C++ as libridc @ChristliebEtAl2010 using OpenMP.

// APPLICATIONS
In the past 6 months there have been 40 publications relating to PinT.
Some of these investigations have applied these PinT methods to science and engineering problems such as:
- Stochastic models of electricity and magnetism @ZhangEtAl2025.
- Continuous-time optimal control problems @SärkkäEtAl2025.
- Additive manufacturing @StumpEtAl2025.
- Optimal control for quantum computing @PeterssonEtAl2025
- Training neural networks @ParpasEtAl2025
- Magnetohydrodynamics for plasma simulations in clean energy @PamelaEtAl2025
- Game theory @LjósheimEtAl2025
- Kinetic plasma simulations @LaidinEtAl2025
- Formations of animal patterns in mathematical biology @Jimenez-CigaEtAl2025
- Dynamics of financial markets with physics-informed neural networks @IbrahimEtAl2025
- Topology optimization of transient heat conduction in materials @AppelEtAl2025
- Fluid-solid interactions in deformable porous media @AlesEtAl2025

While not published this year, honorable mentions go to:
- Long-time simulations of blood flow in fish @Blumers2021 
- Time parallel gravitational collapse simulation @Kreienbuehl_2017
- Fluid-structure simulations @FarhatEtAl2003, and non-linear structural dynamics @CortialFarhat2009
- Massively space-time parallel N-body solver @SpeckEtAl2012

Additionally, the aforementioned implementations have focused on using the traditional "workhorse" languages of HPC: C, C++, and Fortran.  
While these languages offer top-tier performance, scientists without expertise in them are unable to use their associated PinT implementations without first spending too much time learning the language.  
The Julia language was created to solve this "two language" problem with "the speed of C with the ease of Python" by using LLVM for just-in-time compilation and by being built from the ground up with high-performance scientific computing in mind.  
Julia seems to be the future of scientific computing, so there should be support for these PinT algorithms in it.

Needless to say, PinT methods have shown significant performance gains for a wide ranging collection of sciences.  
Because of this, it is paramount that PinT methods see continued support and implementation using high-performance methods and in scientist-focused programming languages.  
That's why this work provides an implementation of the PA using both massive multithreading on GPUs and scalable multiprocessing in the modern scientific computing language Julia.

= The Parareal Algorithm <sec:parareal>

Simulating physical processes has traditionally been done sequentially; even during the modern age of hardware supporting parallel execution, using computers to calculate the evolution of physical phenomena has been sequential.  Why haven't scientists just started doing things in parallel? Because of that pesky thing call _causality_; _the ball must go up before it can come down_.  Because of this temporal dependence (spatial dependence has had its own workarounds such as the Barnes-Hut algorithm @Barnes1986 @Hamada2009), simulation of large-time-scale physics has thus taken a long time to execute.  The PA, and other parallel-in-time integration algorithms, have been developed in the last few decades to specifically address this issue @parareal_og_2001.
// These paragraphs should be squished together, after the above gets trimmed down
Many details and variations of the PA have been investigated to find and address issues such as stability /* #cn */, convergence rates /* #cn */, application to higher-order differential equations /* #cn */.  The main goal of this investigation is to contribute another variation: an implementation of the PA using methods from high-performance computing.

Before the PA can be implemented using these high-performance methods, the algorithm must be decomposed into its central components.  The PA begins by partitioning a single IVP into several IVPs on smaller domains via an initial, inaccurate, "root" solution.  Then each of the "subproblems" are solved using a sequential, accurate method on different threads at the same time.  The final data for each of the subsolutions is then combined with the respective data of the root solution to yield a more accurate (i.e. "corrected") root solution.  This new root solution is then used to repeat the process until convergence.

The interpretation of the PA in terms of these recursive subproblems makes the algorithm _almost_ embarrassingly parallel; the corrections to the root solution need to be done sequentially.  In addition to this structure, the algorithms being evaluated in parallel manifestly depend on simple arithmetic; because of this simplicity, the PA is well-suited to be evaluated on the GPU.  Likewise, distributed methods can be combined with GPU evaluation for further parallelization for either a single model (taking advantaged of the recursive nature of the PA) or a system of models.

This chapter begins by casting the PA in a form that is conducive to being scaled.  The main idea is to recast the "magical" mechanism of the PA to something that can be executed recursively.  In other words, the PA takes an IVP and produces a collection of IVPs, which can each be given to another instance of the PA. The latter half of of this chapter is devoted to presenting a model for which the scalable version of the PA can be implemented.  This model includes how the performance of the PA can increased by using a GPU on a single machine, as well as how to build and use a cluster of machines to further increase performance.

#let tmax = 8
#let threads = 8
#ex To help understand and clarify the mechanisms of the scalable PA, including the important details that are not explicitly covered in the algorithm itself, an example problem is used.  Consider the motion of a thrown ball just after it leaves the hand over the course of #tmax seconds (ignoring air resistance).  This motion is modeled by: $P = {
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
}.$ <eq:root>
The machine has #threads cores.

Physically, *equations of motion* (EOM) (section @sec:parareal_eom) are considered in this work to be second order differential equations describing the motion of objects.  Another way of interpreting an EOM is as how the acceleration of an object over time depends on the object's position and velocity at that time.  The solution to an EOM is simply the position of the object as a function of time, from which the velocity can be derived.  The EOMs alone though only provide the behavior of how the position and velocity of the object _changes_ over time.  In order to uniquely define a path the object takes, initial values for the position and velocity must be stipulated.  The EOM together with these initial values, then define an *initial value problem* (IVP).  These IVPs have long been studied, but investigations into physics at the most extreme scale have required significantly more resources.

== Review of Equations of Motion <sec:parareal_eom>

According to classical mechanics, the motion for any and every object in the universe can be determined for all time using only its current position, current velocity, and the forces acting on it @Landau1976Mechanics. The foundation on which this principle lies is the _equation of motion_ (e.g. Newton's Second Law), which dictates how motion changes in time, or both time and space.  These EOMs can be solved via numerical methods, but some methods better suited for specific problems than others, especially when considering the tradeoff between the accuracy of the result and the level of approximation.  Additionally, some straight-forward methods solve the EOM by accurately stepping through time, but others first make an estimate of the solution, somehow make corrections to that guess, and then keep doing that until the desired accuracy is achieved.

=== Initial Value Problems

Take, for example, the motion of a simple pendulum.  While the overall motion of bob is determined from length on which it hangs, and the gravity affecting it, the angle at which the bob finds only depends on time.  Now, the position of a point on a guitar string does not only change in time, but is also affected by the motion of the points around it.  Both of these systems can be modeled by an EOM, but the pendulum can be modeled an *ordinary differential equation* (ODE), and the guitar string can be modeled by a *partial differential equation* (PDE).

The nuances on each of these ideas are better left covered by your friendly neighborhood math department, but the detail that is indeed important to this work is that there are techniques that can transform a PDE to a collection of ODEs.  One such procedure is known as the _spectral method_, where by representing the solution to the PDE as a sum of waves (i.e. a Fourier transform), the physics in each dimension only affects the frequency in that dimension @Orszag1969.  While the solutions to the ODEs would be in so-called "frequency space", applying the inverse Fourier transform on those solutions, achieves the desired solution to the original PDE.  Whether it be an ODE, a PDE, or a system of ODEs, when modeling physical phenomena, initial values need to be considered to make any concrete predictions about the future state of a specific object.

For our purposes, an IVP can be thought of as an object with several properties: the acceleration, the initial position and velocity, and the time interval on which you are modeling (which could be unbound e.g. $[0, infinity)$) as shown by the following equation:

$ {
  underbrace(
    diff_t^2 harpoon(r) = harpoon(F)(t, harpoon(r), harpoon(v)),
    "Acceleration"
  ), #h(11pt)
  underbrace(
    harpoon(r)(0) = harpoon(r)_0 \, #h(5pt)
    harpoon(v)(0) = harpoon(v)_0,
    "Initial values"
  ), #h(11pt)
  underbrace(
    [0, t_f],
    "time span"
  )
}. $

In some sense, anything that fits this structure, could be considered an IVP (more on this in @sec:parareal_parareal).  Because initial values "lock in" the trajectory of an object based on the EOM's physics, the IVP can be solved numerically.

=== Energy Drift & Symplectic Integrators <sec:energy_drift>

When it comes to solving EOMs numerically, possibly the biggest factor that should influence the choice of integration method is the length of time on which the EOM is considered.  Almost all methods are not inappropriate to use on small scale problems, but some of these methods result in inaccurate or even unphysical behavior due to the accumulation of approximation-error.  For EOMs, one way to quantify this error is through the idea of *energy drift*.

Outside of considering the energy of the whole universe, the total energy of a (well-defined) system does not change in time.  If a system is composed on multiple objects, then the total energy of each object individually can change, but the total energy of all the objects combined is constant.  This simple idea provides a reference with which to compare the simulated energy.

The difference between the simulated energy at any point in time and the initial energy acts as a measurement of the inaccuracy of the simulation at that point in time i.e. the _local error_. A corollary to this is that the difference between the energy at the end of the simulation and the initial energy serves as a measure of the _global error_ as the local error compounds over time.  In other words, the energy of the system _drifts_ away from the true value as error is compounded.

While almost all methods _can_ be used for any problem, some methods result in less energy drift for the same time-step.  A specific class of these methods is known as *symplectic integrators*.  The underlying reasons for this are out of the scope of this work, but an important note is that even though these methods mitigate the effects of energy drift substantially, they do not yield exactly zero drift @RackauckasSymplectic.  It is these symplectic integration methods that are considered in this work.

=== Iterative & Multiple-Shooting Methods

When it comes to simulating physics that only depends on spatial behavior, certain methods can be used that aren't immediately available in the time-dependent case.  Two classes of these methods are _iterative_ and _multiple-shooting_ methods.  An *iterative method* can be considered a form of "guess and check" algorithm where an initial solution is given, some quantity is calculated using this solution, and then the process repeats after adjusting the solution to potentially result in a "better" calculated quantity.  A *multiple-shooting method* is when one big problem is divided into many problems, each of which only considers a subset of the original domain, and each of these problems is solved independently such that the its values at the domain boundaries agree with those of its neighbors.

An iterative method known as the Hartree-Fock algorithm (also known as the Self-Consistent Field Method) can be used to find the configuration of atoms and molecules that minimizes the system's quantum energy @cramer2013essentials.  Likewise, multiple-shooting methods have been used for solving optimal control problems @BOCK19841603. While these methods have traditionally been used for spatial physics, this work relies on the combination of these principles to solve time-dependent problems.

== The Parareal Algorithm <sec:parareal_parareal>

The main idea of the PA is to break up a single IVP into many smaller IVPs using some low-accuracy solution, solve those in parallel using high-accuracy methods, correct your initial solution using the sub-solutions, then make a new low-accuracy solution based on the corrected data, and repeat this process until the solution doesn't change.  The end result of this procedure is a solution identical to one produced by directly using the high-accuracy method while potentially taking a less time @gander2007.  Because the PA wraps traditional (sequential) solvers, it could be considered a "meta-" or "higher-order" method to solve IVPs.

=== Preparing the subproblems

Let the second-order initial value problem $P$ be defined such that

$ P = {cal(L)(t, u, diff_t u, diff_t^2 u) = f(t), #h(11pt)  u(0) = u_0,  diff_t u(0) = v_0, #h(11pt) [t_0, t_0 + Delta t]}, $ <eq:ivp>

and $D = [t_0, t_0 + Delta t]$ is the closed time interval from $t_0$ to $t_0 + Delta t$. The discretization $N$ of $P$ should be determined by the number of available threads $N_t$ such that $N = m N_t$, for some positive integer $m$.  The discretization should be chosen in this manner for maximum performance and efficiency; if $N = m N_t + r$, and $0 < r < N_t$, each thread will solve a subproblem $m$ times until on the $m+1$ iteration where only $r$ threads would be active while $N_t - r$ threads idle (assuming all threads are synchronized).  This type of optimization is sometimes referred to as "_flooding the threadpool_" to mitigate _thread starvation_ /* #cn */.

With the discretization decided, partition the time domain $D$ into subdomains $D_p$ such that

$ D_p = [t_0 + p / N Delta t, t_0 + (p + 1) / N Delta t] = [t_p, t_(p+1)]. $

Use a fast integration method $cal(G)_0$ (such as the Euler method) to compute initial root solutions ${u_p^0}_p$, ${v_p^0}_p$ defined such that

$ {u_p^0}_p = {u_0^0, u_1^0, u_2^0, dots, u_(N-1)^0} $
$ {v_p^0}_p = {v_0^0, v_1^0, v_2^0, dots, v_(N-1)^0} $

and ${u_p^0, v_p^0} = cal(G)(Delta t, u_(p-1)^0, v_(p-1)^0, diff_t^2 u)$.

Subproblems $P_p$ take the same from as in @eq:ivp (this also means subproblems are themselves, problems), but instead using initial conditions defined by those in the initial root solution.  For example, the subproblem $P_1$ for the second ($p = 1$) subdomain, takes the form

$ P_1 = {cal(L)(t, u, diff_t u, diff_t^2 u) = f(t), #h(11pt)  u(0) = u_1^0,  diff_t u(0) = v_1^0, #h(11pt) [t_p, t_(p + 1)]}. $ <eq:example_ivp>

@alg:prep_subproblems shows the pseudocode of this process for a given IVP and integration algorithm i.e. "propagator", resulting in root solutions and and the collected subproblems.  With these subproblems in hand, the PA continues to its next stage: propagating these problems in parallel.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
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
    "images/root_solution.png",
    width: 100%,
    alt: "Plot showing the height of the ball vs time so that each subproblem is a column with its initial position as a blue dot at the start of each subdomain, and its velocity as a blue arrow coming from the respective dot.  The true solution is also shown with the same form but in black."
  ),
  caption: "The motion of a ball flying through the air can be partitioned in time to form several initial value problems, each with its own initial position and velocity (upper, blue) determined by a fast integration method. Compared to the true solution (lower, black), this solution is very inaccurate."
) <diag:it_0>

//
=== Solving the subproblems

Discretizing the domain and propagating initial values as in the previous section constitutes the application of the _coarse propagator_ $cal(G)$ to the root problem.  Because each of the produced subproblems is independent of the others, each can be accurately solved in parallel using a _fine propagator_ $cal(F)$ to reduce the total runtime by a factor equal to the number of subproblems.  In other words, if applying $cal(F)$ to a single subproblem has a runtime $tau_cal(F)$, then applying $cal(F)$ to the root problem directly has a runtime $N * tau_cal(F)$ because there are $N$ subproblems, whereas applying $cal(F)$ in parallel only results in a runtime $tau_cal(F)$ because each application of $cal(F)$ executes at the same time.

In general, a *propagator* $cal(P)$ is defined by two key components: its integration algorithm $I_cal(P)$, and its discretization $N_cal(P)$. More specifically, the propagator $cal(P)$ can be interpreted as a higher-order function mapping integration algorithms and discretizations to functions that, when applied to an IVP, reduce to sequences ${(t, harpoon(r)_t)}_t, {(t, harpoon(v)_t)}_t$ of time-position and time-velocity pairs, respectively; the collection of the sequences is called the *solution* $S_P$ of $P$.  The solution can be interpreted as the set of function-graphs (as defined in @pinter2014book) of $harpoon(r)$ and $harpoon(v)$, and is defined such that

$ cal(P)(I_cal(P), N_cal(P))(P) = {{(t, harpoon(r)_t)}_t, {(t, harpoon(v)_t)}_t} =: S_P. $ <eq:solution>

The application of the propagator to the subproblem is the core, or *kernel*, of the PA. While this description of the kernel is useful for understanding, it does not immediately lead to an algorithm that is well-suited for hardware-agnostic implementation (more details in #lower([@sec:scale_gpu]) on #ref(<sec:scale_gpu>, form: "page")). To that end, the implementation of the kernel presented here is composed of discretizing the subdomain and propagating the initial values separately.

*Discretization:* To avoid performance losses from each kernel allocating memory, each discretization kernel references a specific, pre-allocated, one-dimensional array $delta D$ of length $N_cal(P)$.  In order for the kernel to generate the appropriate samplings of the domain, $delta D$ has its first and last elements pre-populated with the values of the lower and upper bounds of that thread's assigned subproblem such that

$ delta D = {t_p, [N_cal(P) - 2 "arbitrary elements"], t_(p + 1)}. $

With each kernel accessing this data, it can simply calculate and write the domain samples in-place; this process is shown in @alg:disc_kernel.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
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

Otherwise, the propagation kernel is no more than a traditional IVP solver as described in @sec:energy_drift, but executed on many different subproblems simultaneously over many threads.  This process is shown algorithmically in @alg:prop_kernel.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
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
  supplement: [Algorithm],
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
    "images/parallel_propagation_intermediate.png",
    width: 100%,
    alt: "The same plot as before, but now also with a curve of small, red dots coming from each initial position progressing to the right."
  ),
  // square(width: 40%, [some stuff]),
  caption: [Each thread uses coarse and fine propagators to produce intermediate values (small, red dots) from the initial values (big, blue dots and arrows) of its assigned subproblem.  Velocity data does exist, but is neglected here for visual clarity.]
) <diag:disc_prop>

// The solution structure as in @eq:solution is recovered by combining the results of the discretization and propagation kernels according to the algorithm in @alg:solution_constructor.  The separation of the discretization and propagation kernels allows the discretized domain to be only calculated once, while being used in both the solutions for the position and velocity.  Further advantage is taken in the next section.

// #figure(
//   kind: "algorithm",
//   supplement: [Algorithm],
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
  - *Note:* If there are more problems than threads, the kernel can index stride @Harris2013; more on this in @sec:scale_gpu.

=== Solving the root problem <sec:corrections>

Because the root solution has been calculated via an inaccurate method, it can be made more accurate using the results of the fine propagator.  Though the root solution is not corrected only with the results of the fine propagator, but rather by coarsely propagating the root initial values again but adding a corrector determined by a combination of the results of the fine propagator and the previous iteration's root solution.  The main idea of this process is known as _Deferred Corrections_ @Ong2020.

The correction phase, as defined in literature @parareal_og_2001, takes the deceptively-simple recursive form

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
  supplement: [Algorithm],
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

=== Converging the root solution <sec:parareal_parareal_converging>

Finally, as own in @alg:parareal, launch the parareal kernel (@alg:parareal_kernel) to gather the fine solutions for each point in time, and construct the new root solution (@alg:correction) until the root solution stops changing between iterations.  While there are many choices that can serve as valid convergence criteria @gander2007, one of the simplest is:

$ max_(1 <= t <= N-1) |u_t^i - u_t^(i-1)| < epsilon, $ <eq:convergence>

for some threshold $epsilon$.  @eq:convergence determines convergence when every point in the solution changes by less than some amount between iterations.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [The PA is composed of looping two steps: finding the fine solutions in parallel, then finding the root solution sequentially.  The loop stops when the root solution stops changing.],
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
The magic of the PA lies in its divide-and-conquer approach to solving initial value problems.  The "root" problem is sequentially and inaccurately solved to divide it into smaller problems whose initial values are defined by the solution.  Those problems are simultaneously and accurately solved in parallel.  The root problem is then solved in the same way as before, but at each step, the data is modified by combining the previous accurate and inaccurate solutions.  Finally, the new root solution defines new problems, and the loop continues until the the solution has converged.

= The Parareal Algorithm at Scale <sec:scale>

@sec:parareal_parareal highlights the PA's nature of being quasi-embarrassingly-parallel i.e. the performance of the algorithm scales with the number of threads, while still being bottlenecked by a periodic sequential process. That being said, the previous discussion ignores the details and nuances of implementing the PA including the actual form of the threads.  The primary goal of this work is to provide two new implementation models that both take advantage of increased parallelism and allow easy scaling: using the massively parallel architecture of graphics processing units (GPUs), and the scalability of distributed systems. Instances of these implementations are also provided @Chapman_PararealGPU_jl.

The PA as defined in @alg:parareal does not change in it _what_ it does when implemented to use GPUs, but rather _how_ it does.  There are several issues that arise when utilizing general-purpose GPU computing (GPGPU) such as the GPU needing to wait until the CPU tells it to do something, better performance with less precision, and the restriction to using primitive types like "ints" and "floats".  Though, the biggest issue is the need to consider the movement of data between RAM and VRAM, or more generally host memory and device memory; considering unshared memory spaces will be even more important in section @sec:scale_distributed.

The distributed-based implementation focuses on distributing problems across multiple remote machines.  These machines solve their problems simultaneously with the other machines, thus achieving a form of parallelism only limited by the number of accessible machines. These problems could either arise from the coarse propagation of a single root problem, yielding a "problem tree" (/* @diag:problem_tree */) where each machine would create-distribute-collect its own set of problems, or if there are multiple "true root" problems e.g. a system of ODEs.

The GPU- and distribution-based methods can be combined to further parallelize solving an initial value problem.  If each of the machines available to the distributed network has at least one GPU (a single machine can have multiple; more details in @sec:scale_distributed), this implementation will automatically identify, manage, and use all of them.  Thus these methods can be composed to provide a scalable model of parallel-in-time integration for equations of motion.

High-performance computing (HPC) (section @sec:scale_hpc), in the context of this work, focuses on utilizing two core ideas: *multithreading & GPU computing*, and *multiprocessing & distributed computing*.  These ideas contrast _sequential_ procedures where the next calculation cannot be started before the previous has finished.  Multithreading, and more specifically using graphics processing units (GPUs) to do general purpose computation i.e. GPGPU computing, allow several calculations to be done simultaneously on the same physical hardware i.e. in _parallel_.  Further extending this idea, multiprocessing (not to be confused with multi-_threading_) allows calculations to be executed simultaneously as in the case of several threads, but these calculations "have their own set of knowledge".  This seemingly subtle distinction provides the ability for these multiple processes to be executed on _different_ physical hardware.  These models of parallelism have been used in the past to address the runtime issues arising from simulating complex physical phenomena.

== Review of High-Performance Computing <sec:scale_hpc>

When problems get big enough, or more concretely when there is enough data that needs to be processed, traditional computers are unable to complete the task in a reasonable amount of time.  When such cases arise, not only are more performant computers needed, but also the methods used to _implement_ the calculations need to be changed as well.  In essence, *high-performance computing* (HPC) is about performing as many as calculations as possible in the least amount of time.  One of the most direct methods to reduce the time needed to perform calculations is to "simply" perform multiple of them at the same time, otherwise known as *parallel processing*.  There are several ways in which parallel processing can be achieved; some of which being using a multi-core CPU, a GPU, and multiple physical computers.

@sec:multithreading covers the basics of utilizing multiple _threads_ to perform computations simultaneously.  In the case of _multithreading_ for HPC, even using multiple threads on a CPU is insufficient as CPUs are only capable of performing, at the time of writing, on the order of 10s of calculations simultaneously.  For this reason, the massively-parallel architecture of GPUs has been utilized to performing 10s of _thousands_ of calculations simultaneously.  Though the extra power does not come freely.

@sec:multiprocessing covers the basics of utilizing multiple _processes_ and even multiple physical machines to perform _many_ calculations simultaneously.  Much like multithreading, the potential performance increase from utilizing multiple processes on a single CPU is still limited by its "10s of calculations" ability, and in fact is lower than with multithreading due to processes needing more resources to exist.  Unlike multithreading, multiprocessing allows for calculations to be distributed amongst resources that are not even physically located on the same machine, allowing for theoretically _unlimited_ performance increases.  Though, like multithreading, this utilizing this power does not come without its challenges.

One of the core goals of this work is to combine the power of massive multithreading from GPUs and the unbound potential from distributed computing to solve EOMs.  This will allow "extreme-scale", time-dependent problems to be solved in reasonable time.

=== Multithreading & GPU Computing <sec:multithreading>

For the purposes of this work, there are three ideas that need to be understood.  The first is that data needs to be copied between the CPU and the GPU. The second is how the GPU can read and write that data safely.  Finally, the third is how the GPU performs calculations on that data.  A note on terminology: when discussing GPGPU computing, the nomenclature refers to the memory and overall system accessible to the CPU as the *host*, and similarly the memory and resources available to the GPU is known as the *device*.

When data is processed and stored by the host in RAM, that data is not automatically accessible to the device.  The device has its own memory and can only read and write to it, so any data that is used on the GPU must first be copied to it.  When the device has finished its calculations and written the new data to its memory, that data must then be copied from the device to the host.  This host-device communication is orders-of-magnitude slower than the communication between the resources on the device @Harris2012, and thus should be minimized.  Note this does not take into account the time needed to _allocate_ memory, which only exacerbates the issue.

The data that's transferred between the host and device usually takes the form of an array.  Because each thread on the device executes the same program (called the *kernel*), each thread needs to access different elements of the array based on its position relative to the other threads.  This follows the _single instruction, multiple thread_ (SIMT) model of parallelism.  This pattern of indexing is shown in @img:cuda_indexing.

#figure(
  caption: [Each thread accesses an index of the array (`index`) based on the thread's location (`threadIdx.x`) in its block, how many threads there are in its block (`blockDim.x`), and the block's location (`blockIdx.x`) in the grid. Image credit @Harris2017.],
  image(
    alt: "",
    "images/cuda_indexing.png",
    width: 100%
  )
) <img:cuda_indexing>

When there are more elements in the array than there are threads on the device, each thread must process multiple array elements. Once each thread is finished writing to its index (either in-place to the original array, or to another array copied from the host), it "jumps over" all the indices that were just written to by all the other threads in all the other blocks, and writes to the next one.  The number of indices the thread "jumps", called the _stride_, is determined by the number of threads in each block (`blockDim.x`) and the number of blocks in each grid (`gridDim.x`).  This is known as _index striding_ and is frequently used in GPU programming to process arrays of arbitrary dimension @Harris2013.  This idea is shown in @img:cuda_stride.

Once each thread knows its array index, all threads execute the kernel simultaneously.  This is where the increased performance comes in.  If the program takes $T$ time to execute on a single array element, and there are $N$ array elements, then the total time to calculate sequentially would be $T N$.  Because the device processes each element simultaneously (as long as there are more threads than elements), the total time to calculate is that of a single execution i.e $T$.  If there are $M$ times as many elements are there are threads, then the total time would simply be $M T$ as each thread processes $M$ elements.  Further parallelization can be achieved by distributing the array elements over multiple devices and machines.

#figure(
  caption: [The indices a specific thread processes are based on how many total threads there are.\ Image credit @Singal2021],
  image(
    alt: "",
    "images/grid-stride-1.png",
    width: 100%
  )
) <img:cuda_stride>

=== Multiprocessing & Distributed Computing <sec:multiprocessing>

The three most important ideas to understand in multiprocessing and distributed computing for this work are: different processes do not have access to the same data, one process can tell another to perform an action, and the time associated with communicating between processes.  To distinguish processes and threads, consider two homes A and B each with its own family.  Each home represents a process with its associated family members being that process's threads.

// Unshared memory spaces
Unlike threads, the context, or _memory space_, a process has is distinct from that of other processes.  Thus, if something changes in one process, other processes are unaware of the change.  Considering the analogy, if home A's phone is moved from the dining room to the living room by Alice who then writes the new location on the fridge, the other family members in home A can all see this change because they all have access to the same fridge.  As for home B, not only does the home phone not move, but family B also does not know home A's phone moved, because they do not have access to home B's fridge.  It is only when information is explicitly communicated between these processes/homes that the other has this new information.

The communication of data between between processes is much slower and requires much more overhead than communicating between threads.  Considering the analogy, when a family member in home A can't find the phone, they simply go to the fridge for the updated information.  If, for some reason, family B needs the location of family A's phone, someone from family A would probably walk over to home B and update them.  This takes much more time and resources than going to the fridge in the same home (and even more time and effort is required to update in the next town over!).  But what if Bob in home B wants Alice in home A to do something?

#pagebreak()
*Remote Procedure Calls:* While there are many methods to communicate information between processes, the most important method for this work involves one processes telling another process to execute some procedure, which is aptly named a _remote procedure call_ (RPC).  RPC allows one process, such as the one launched by a user running a program, to direct another process to execute some command using its own resources.  Though, because each process has its own memory space, any references to objects that don't exist in the _remote_ process e.g. variable, libraries, etc., will fail, and references to objects "with the same name" can produce unintended results.

In the analogy, Alice in home A wants to compare the location of her phone to the location of Bob's phone in home B, so she asks Bob "Where is the phone?".  Because both homes have phones, but they are in different locations, Alice would answer "the living room" and Bob would answer "the kitchen" because "the phone" is relative to each home.  If Alice and Bob wanted to have the same answer, then either they would have to communicate where they want the phone to be and put it there, or refer to the same physical instance of a phone.

Out of the analogy, each remote host effectively needs to be an identical copy of the local host.  This can be achieved by each host referring to a shared file system so they all manifestly the same binaries, versions of packages, etc. This needs to happen because an RPC can be thought of as sending a chunk of raw, textual source code to be run on the other process and/or machine.  If that source code calls some functionality that is not loaded or otherwise available in that process, that call will error. Thus things like a GPU library must be not only available on each machine, but also loaded on each process.

== Parareal on the GPU <sec:scale_gpu>

The GPU-based implementation focuses on three ideas. The first is utilizing the massively-parallel architecture of a GPU to _simultaneously_ use orders-of-magnitude more threads than what would be possible with a CPU.  The second is considering the movement of data between the host memory (RAM) and the device memory (VRAM). And the last is needing to use primitive data-types.  Otherwise, the underlying algorithm is no different than what is presented in @sec:parareal_parareal.

The PA (@alg:parareal) is only limited by the number of threads at its disposal.  When the number of threads is greater than the number of cores, the processor needs to switch thread contexts in order to balance the evolution of each thread.  On a CPU, this context switching is very costly and can lead to drastic decreases in performance @stallings2011operating @Li2007.  On a GPU however, switching thread-contexts is nearly free @cook2012cuda, allowing there to be _many_ more threads than processors without sacrificing efficiency.  So, it is very beneficial to execute the PA on hardware that not only can efficiently handle many threads, but also have them running at the same time.

All relevant data is first allocated and pre-populated by the CPU on the host.  Then the CPU copies that data to the device. Then the CPU tells the GPU to execute the parareal kernel on its copy of the data, producing solution data. The CPU then copies the solution data from the device to the host and recreates the problems.  The transfer of data (and the CPU launching the kernel on the GPU) between the host and the device serves as the main performance bottleneck in this process. @cook2012cuda Dynamic parallelism can be used to launch kernels directly from the GPU, thus circumventing the performance drawbacks of host-device communication @cook2012cuda.

GPUs can only process primitive types of data such as integers, floats, booleans, and other "bits-types".  This precludes collecting the problem and solution data in more intuitive forms like one would do when representing them mathematically.  In other words, whereas a CPU is happy to handle several boxes each with its own set of elements e.g. domain, acceleration, initial position, and initial velocity, GPUs need this same underlying data to be collected such that all domains are in one box, all acceleration functions are in another box, all initial positions are another, and initial velocities in another.  These "boxes" take the form of arrays.  It is for this reason, the PA as described in @sec:parareal_parareal uses its data as arrays.

So, why is the PA well-suited to be implemented to use GPUs?  Because the data is only composed of numbers, it can be simply represented in a GPU-friendly array structure.  The massive number of cores on a GPU can simultaneously process these arrays with a much lower cost of switching between threads and problems.  And finally, the solution data can be easily copied back to the host.  This process is shown in @alg:parareal_gpu and @diag:gpu_propagation.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [The PA is composed of looping two steps: finding the fine solutions in parallel, then finding the root solution sequentially.  The loop stops when the root solution stops changing.],
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
    "images/parallel_propagation_gpu.png"
  )
) <diag:gpu_propagation>

== Parareal on the Cluster <sec:scale_distributed>

While the PA can be further parallelized using GPUs, the fact still stands that the PA is quasi-embarrassingly-parallel.  In other words, each subproblem is independent of the others while each is being solved, and each of these subproblems can be assigned its own thread.  So, if there are more threads available, higher performance or accuracy can be achieved.  The implementation presented here provides more threads by sending problems to remote machines where they can be run simultaneously; in other words, multiple machines with their own CPUs and GPUs are networked together to form a _cluster_ where the work is distributed amongst all machines.

#figure(
  image("images/cluster_topology.png", width: 80%),
  caption: [The assumed topology of the cluster presented in this work.]
) <diag:cluster_topology>

While clusters can take many forms /* #cn */, this implementation considers building a cluster from the ground up in a modular and ad-hoc manner.  This way the cluster can theoretically scale without limit.  The general strucutre, or _topology_, of the cluster is rather simple: A _head node_ runs the _director_ process, which tells _worker_ processes on other _compute nodes_ what to do; this structure is shown in @diag:cluster_topology.  In other words, the director only decides and does not do, while the workers do not decide and only do.  While the workers can solve their problems and communicate with every other worker (and the director), only the director can spawn new processes.  Once the director has finished spawning and configuring the workers as in @alg:cluster_prep, the director moves on to begin the PA.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [The cluster can be created and prepared in 4 simple steps.],
  pseudocode-list(
    numbered-title: smallcaps[Prepare the Cluster],
    booktabs: true,
    hooks: 0.5em
  )[
    - *INPUT:* A collection of hosts not ready to compute
    - *OUTPUT:* A collection of hosts ready to compute
    + Director process spawns manager processes on each host
    + Each manager sends the number of devices on its host back to the director
    + Director process spawns worker processes on each host, 1 for each device on that host
    + Pair each worker with a device on its host
  ]
) <alg:cluster_prep>

In order for this implementation to be flexible, the director does not assume any a-priori configuration of any worker nodes.  This way any node can be seamlessly introduced to the cluster.  The drawback of this flexibility is that the cluster must be created each time.  Part of this creation is identifying the available devices in the cluster.  To do this, the director first uses a user-given collection of hostnames to spawn a single "manager" process on each of the given hosts.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [Manager processes are created to identify the number of devices on a host, and can manage the network communication between hosts.],
  pseudocode-list(
    numbered-title: smallcaps[Spawn Manager Processes],
    booktabs: true,
    hooks: 0.5em
  )[
    - *INPUT:* A list of hosts
    - *OUTPUT:* A list of manager process IDs
    + The director spawns manager process on each host
    + The director tells each manager to load the Parareal library
  ]
) <alg:spawn_managers>

Once the managers have been spawned, the director asks them how many devices are on their host.  The manager measures this and sends back the information to the director.  The director, because it is the only process that can spawn workers, spawns a number of workers on each host equal to the number of devices on it.  This process is shown in @alg:spawn_workers.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [Worker processes are spawned by the director on each host\ based on the number of devices available to that host.],
  pseudocode-list(
    numbered-title: smallcaps[Spawn Worker Processes],
    booktabs: true,
    hooks: 0.5em
  )[
    - *INPUT:* A list of manager IDs
    - *OUTPUT:* A list of worker IDs
    + The director tells each manager to load the GPU library \/\/ _provides ability to count devices_
    + The director requests the number of devices on the host from each manager
    + For each host
      + For each device on the host
        + The director spawns a process on the host
    + The director tells each manager to load the Parareal library
  ]
) <alg:spawn_workers>

Once the workers are spawned on their respective hosts, each of them needs a device.  While the fundamental idea of assigning a device to a worker is trivial (as shown in @alg:assign_devices_high), the implementation suffers from the fact the a device should not be assigned to a process on a different host!  In this implementation, process IDs correlate to the order in which they were spawned e.g. process 2 was spawned second, process 3 was spawned third; in other words, the process IDs are relative to the whole cluster.  The device IDs, however, are relative to their host machine.  So, care must be taken in order to pair processes and devices on the same host.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [Pairing workers and devices is trivial at a high level],
  pseudocode-list(
    numbered-title: smallcaps[Assign Devices - High Level],
    booktabs: true,
    hooks: 0.5em
  )[
    - *INPUT:*
    - *OUTPUT:*
    + The director tells each new worker to load the GPU library \/\/ _provides ability to assign devices_
    + For each host
      + For each worker on that host
        + The worker assigns an on-host device to itself
  ]
) <alg:assign_devices_high>

For example
- The director has process ID (pid) 1 and is on its own host.
- Host X has pid 2, and host Y has pids 3, and 4.
- Host X has 1 device with ID 0, and host Y has 2 devices with ID 0 and 1.
- The desired result is
  - Device 0 on host X is assigned to pid 2
  - Device 0 on host Y is assigned to pid 3
  - Device 1 on host Y is assigned to pid 4

One way to address this issue is to create "host objects" by collecting the hostnames, pids, and number of devices for each host.  The collection of these host objects, together with their relative connections, would constitute a "cluster object" or "cluster graph".  While the actual ids of the devices on each host are what is important, the pattern is the same for all hosts e.g. `devids = 0, 1, ..., ndevs-1`.  This way only a single integer needs to be stored instead of a list.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [To aid in the pairing of devices and workers, host objects can be created to make sure devices are assigned to workers on the same host.],
  pseudocode-list(
    numbered-title: smallcaps[Create Host Objects],
    booktabs: true,
    hooks: 0.5em
  )[
    - *INPUT:* List of hostnames, list of managers, list of device counts
    - *OUTPUT:* List of host objects `hosts`
    + For each host
      + `name` #gets name of host
      + `workers` #gets list of woker IDs on host
      + `ndevs` #gets number of devices on host
      + `hosts[i]` #gets `Host(name, workers, ndevs)`
    + *return* `hosts`
  ]
) <alg:create_hosts>

A host object packages together the worker IDs and number of devices on the same host. Thus devices can be assigned to workers on the same machine simply by iterating through the host objects.  This process is shown in @alg:assign_devices.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [A more detailed algorithm of assigning devices to workers on the same host.],
  pseudocode-list(
    numbered-title: smallcaps[Assign Devices],
    booktabs: true,
    hooks: 0.5em
  )[
    - *INPUT:* List of host objects `hosts`
    - *OUTPUT:* Nothing
    + Load the GPU library on each worker \/\/ _provides ability to assign devices_
    + *for * `host` in `hosts`
      // + `name` #gets `host.name`
      + `workers` #gets `host.workers`
      + `devids` #gets `(0, 1, ..., host.ndevs-1)`
      + *for* each pair (`worker, devid`)
        + Assign `devid` to `worker`
  ]
) <alg:assign_devices>

Once the devices are assigned, the cluster has been prepared.  The director then becomes the driver of the PA, as shown in @alg:parareal_distributed.  The director begins the PA as it normally would, but instead of either dispatching the parallel propagation to other CPU threads or the GPU, the director gives each worker a problem to propagate in parallel, either on its CPU or GPU.  Since this dispatching takes little time, the director then waits until it gets the solutions from the the workers.  Finally, the director coarse propagates the root problem with the solutions, checks if the solution has converged, and loops if it hasn't.

#figure(
  kind: "algorithm",
  supplement: [Algorithm],
  caption: [The PA can distribute its subproblems amongs multiple machines\ in order to achieve higher performance.],
  pseudocode-list(
    numbered-title: smallcaps[The Parareal Algorithm at Scale],
    booktabs: true,
    hooks: 0.5em
  )[
    - *INPUT:* A root problem, coarse and fine propagators, and a convergence threshold
    - *OUTPUT:* A solution to the root problem
    - \/\/ _on a prepared cluster_
    + The director coarse propagates root problem to get initial solution
    + While the root solution has not converged
      + The director creates problems
      + For each problem
        + The director sends the problem to a worker
        + The director tells the worker to solve the problem using the Parareal algorithm on its GPU
        + The director requests the solution from the worker
      + The director waits to get all solutions
      + The director coarse propagates root problem with corrections to get new solution
  ]
) <alg:parareal_distributed>


= Performance Analysis <sec:analysis>

While there are many significant aspects of this work that could be analyzed, there are only three that will be considered here.  The effects of transferring data betwene the host and the device repeatedly arises only in the implementation and the theoretical nature of this bottleneck is investigated.  Similary, the significance of transferring data between hosts is analyzed.  And finally, empirical benchmarks are given to highlight the efficacy of the implementation.

Numerical analysis focsuses on measuring the effects of numerical approximation.  Some of the most notable effects to conisder are error, stability, and convergence. Instead of considering raw error, in this work energy-drift will be used as a proxy (as outlined in @sec:energy_drift).  In this case, stability refers to how the error of the result changes with respect the length of the time domain of the root problem.  Convergence measures how many iterations the implementation takes to converge against the coarse and fine discretizations.

Algorithm analysis focuses on two main aspects: how the runtime of the program is affected by changes in size of the input, and how the needed amount of memory is affected by changes in the size of the input.  For this work, the "input" will be the coarse and fine discretizations.

Benchmarks

== Numerical Analysis <sec:analysis_numerical>

TALK ABOUT WHY ERROR, STABILITY, AND CONVERGENCE ANALYSIS IS IMPORTANT.

Because the PA acts as a "meta-algorithm", the underlying integration methods must also be chosen.  For these results, the integration schemes for the coarse and fine propagators are the symplectic-Euler and velocity-Verlet methods, respectively.  The symplectic-Euler method is chosen for the coarse propagation because it computationally "cheap" while still being symplectic.  The velocity-Verlet method is chosen for the fine propagation due to its higher accuracy, while still being computationally inexpensive.  While these methods are simliar in their computational cost and accuracy for a single propagation, the multiple resolutions of the time domain provide the ability for the fine propagator to have a higher discretization and thus a much smaller time-step compared to the coarse propagator.

An important item to note is that data here is represented using only 32 bits instead of the de-facto standard of 64.
This restriction is because GPU performance is significantly better when using 32-bit floating point representations ("32-bit floats") compared to using 64.
Though, when both the coarse discretization and the integration method are innacurate (e.g. $N_cal(G) = 4$ with the Euler method), the solution diverges to yield data that is too large to be represented with only 32-bits (the maximum being $approx 10^38$).
Additionally, using only 32 bits increases round-off error and thus accelerates the solution's divergence.
Regardless of the source, these overflows result in a $plus.minus infinity$.

// Iterative algorithms need to test for convergence.
// One method to test if the algorithm has converged is to measure how much the solution changes between iterations, as seen in @eq:convergence in @sec:parareal_parareal_converging.
// When using only 32-bit floats, if the change between solutions is less than the 32-bit machine epsilon $epsilon_M approx 10^(-7)$, taking the difference results in zero.
// It should be noted this behavior is unrelated to the user-given convergence threshold

#pagebreak()
=== Discretization Error & Energy Drift

The error associated with a simulation depends on many factors, but one of the most controllable is that associated with the time-step: the smaller the time-step the closer the simulation is to reality.
The time step used by the coarse propagation only depends on the coarse discretization as $Delta t_cal(G) = T \/ N_cal(G)$ while the time step used in the fine propagation depends on both the coarse and fine discretizations as $Delta t_cal(F) = Delta t_cal(G) \/ N_cal(F) = T \/ N_cal(G) N_cal(F)$.
This section analyzes how the accuracy of the simulation depends on the size of each of these time steps.

Additionally, in order to understand the error of a numerical approximation, it must be compared to a known value.
For this analysis, that reference is the constant energy $E_"true"$ of a simple pendulum under no dissipative nor driving forces.
The error is defined by the deviation of the simulated energy $E_"sim"$ from the true energy after the pendulum has undergone ten oscillations.
In order to enusre measurements are scale independent, the difference in energy is scaled by the true energy to yield the relative energy drift $E_r = (E_"sim" - E_"true") \/ E_"true"$.
In this case the has unit mass $m = 1 "kg"$ pendulum begins at its low point $theta_0 = 0 "rads"$ a distance $ell = 1 "m"$ below its pivot with unit velocity $omega_0 = 1 "rads"\/s$ yielding $E_"true" = m ell^2 omega_0^2 \/ 2 = 0.5 "J"$.

@plt:energy_coarse shows how the error depends on the coarse discretization for several choices of fine discretization.
Notably, for every presented fine discretization, the error seemingly depends not just nonlinearly, but non-monotonically.
Yielding almost quadratic behavior, the error initially decreases for an increase of coarse discretization, reaching a minimum at a coarse discretization of $2^10$ for every fine discretization, then rising again.
This unintuitive behavior warrants futher investigation as the error is expected to exponentially decay converging to zero for larger coarse discretizations.

#figure(
  caption: [The order of magnitude of the normalized percent error of the final state of the pendulum for different coarse and fine discretizations.],
  image(
    "images/analysis/energy_fine_2_9_10_11_14_coarse_2_14.png",
    width: 77%
  )
)  <plt:energy_coarse>

#figure(
  caption: [The order of magnitude of the normalized percent error of the final state of the pendulum for different coarse and fine discretizations.],
  image(
    "images/analysis/energy_coarse_2_9_10_11_15_fine_2_14.png",
    width: 77%
  )
) <plt:energy_fine>

@plt:energy_fine shows how the energy drift of the simulation is affected by the fine discretization for a particular choice of the coarse discretization.
There are two key features that should be noted here: the error decreases significantly even for a small change in the fine discretization but then plateaus only to increase at large values of the fine discretization, and the difference in the difference of error (i.e. $Delta^2 E_r \/ Delta N_cal(F) Delta N_cal(G)$) is non-monotonic for different fine discretizations.
The former signifies that the quality of the results produced from this implementation does not significantly depend on the fine discretiation, until it becomes large.
The latter suggests there is a complex topography of the error-discretization space that warrants futher investigation; a possible starting point would be to explore the fact that $E_r prop Delta t prop 1 \/ Delta N_cal(G) Delta N_cal(F)$.

The results shown in figures @plt:energy_coarse[] and @plt:energy_fine[] show that the error of using this implementation does depend on the size of the coarse and fine discretizations.
More specifically, the error seems to be concave in each of the discretizations, first decreasing with larger discretization before reaching a minimum and then increasing.
Futhermore, there also seems to be concavity in the mixed change of the error $Delta^2 E_r \/ Delta N_cal(G) Delta N_cal(F)$.
These conclusions warrant further investigation of the topography of the error-discretization space of this implementation and of the PA itself.

=== Stability

#figure(
  caption: [The global error of the simulation quadratically increases as the length of the simulation/the number of iterations increases.  This is consistent with the analytically determined global error of the velocity-verlet algorithm being $O(Delta t^2)$.],
  image(
    "images/analysis/stability_cd64_fd8_tf20.png",
    width: 86%
  )
)  <plt:stability>

The notion of stability in the context numerically solving differential equations can refer to the tendency of an integration algorithm to "blow up" due to the accumulation of error.
As each iteration of the algorithm introduces error, the stability of a simulation depends on the number of iterations it undergoes.
For integrating equations of motion, a simulation can iterate more times $N$ for two variations of $t_f - t_i = N Delta t$: the final time $t_f$ of the simulation becomes larger while the time step $Delta t$ stays the same, or the time step $Delta t$ becomes smaller while the time domain $t_f - t_i$ does not change.
While the consequences of the former are relatively simple as the error introduced with each iteration accumulates more and more to create the global error, the latter involves both the decrease in error associted with decrease in time-step and the increase in error associated with the increase of the number of iterations.

@plt:stability shows the global error of the simulation as the time-step remains constant and the final time, and thus the number of iterations, increases.  
The results of the PA are identical to those that would be produced by the using the fine propagator by itself, which in this case is the velocity-verlet method.  
The global error shown is consistent with the known behavior of the global error of the velocity-verlet algorithm $O(Delta t^2)$, which is used here.

=== Iterations

#figure(
  caption: [],
  image(
    "images/analysis/convergence_fd8.png",
    width: 80%
  )
) <plt:convergence_coarse>

#figure(
  caption: [],
  image(
    "images/analysis/convergence_cd64.png",
    width: 80%
  )
) <plt:convergence_fine>

== Data Transfers & Latency <sec:analysis_latency>

As noted in @sec:scale_hpc, any data that is computed in one memory space must be transferred to another memory space in order for that data to be used in that space.  Again, this applies for both GPUs and remote hosts (or more generally processes).  Because these transfers happen over either PCI-E or network channels, respectively, they serve as the single greatest bottlenecks for performance in this implementation. The following discussion will address to what extent this implementation is limited by these bottlenecks and some strategies on how to mitigate them.

To highlight the bottlenecks in the PA, we focus our attention back to @alg:parareal_distributed.  After the director has created the subproblems, it transfers them to each of the worker processes via a network communication.  Then the director has to further communicate that the worker execute the PA on the GPU.  The worker host then transfers the problem data to the worker device.  After the GPU executes the parareal kernel, the new data is transferred back to the host.  Finally, the director requests the new data from the host, to which the worker transfers the new data over the network.

These transfer bottlenecks fall into two classifications: host-device, and host-host communication.  There are several methods that can be used to mitigate the consequences of the host-device transfer, including taking advantage of dynamic parallelism (where the coarse propagation would be done on the device), pinned/page-locked memory, and zero-copy memory.  As for host-host communication, which is done over the network and is the slowest part of the entire implementation, not much can be done to improve it directly other than using faster hardware and/or potentially an optimized cluster configuration, however, the relative efficiency could be improved by transferring as much data at once as possible.

=== Host-Device Data Transfers

// PCI-E is really slow
A fundamental bottleneck, as it's part of the algorithm, is the need for all parallel computation to stop and the serial execution of the coarse propagation to complete.  While the serial execution is itself a bottleneck in terms of performance, the coarse propagation requires the fine-propagation data on the device, and thus it must first be transferred to the host; similarly, the new data must be transferred to the device after it's been created.  These transfers happen over PCI-E, which is really slow compared to the speeds of on-device memory transfers.  In fact, the bandwidth of global memory on a device can be at least an order of magnitude greater than the PCI-E bandwidth @cook2012cuda.

// dynamic parallelism
These slow transfers could be completely circumvented by moving the coarse propagation to a single thread on the device, then using dynamic parallelism to launch the parareal kernel also on the device @Adinets2014.  While a single device-thread is likely to take more time than a single host-thread when performing the same task, the increase in time from this trade is likely to be less than the decrease in time from not needing to transfer data.  Thus the net time difference from this change would be beneficial.  Though, this makes sense only when computing everything locally as any distribution to other nodes would requires the use of the host system or NVIDIA's remote direct memory access (GPUDirect RDMA).

#pagebreak() // - Pinned/Page-locked memory
If the number of transfers is unchanged, the implementation could make use of pinned/page-locked memory.  Pinned memory being memory on the host which the device can access directly without first requesting the host CPU to retrieve it and send it.  Additionally, pinned memory is guaranteed to never /*needs citation*/ be swapped out to disk and thus the device does not need to wait for it to first be transferred to pinned memory @cook2012cuda.  Using this technique could greatly improve performance; the implementation provided in this work does not use it but could be included via library calls @besard2018juliagpu @besard2019prototyping.

// transfer speed depends on size of the transfer
Another point that should be addressed is that the transfer rate between the host and device is not independent of the size of the transfer itself.  On some devices, the transfer rate is nowhere near optimal when then the size of the transfer is below \~2 MB (even with pinned memory), and peak efficiency is only gained with transfers of 16 MB or more @cook2012cuda.  If the coarse discretization is equal to the number of threads the device can execute simultaneously, say $N_t = 5 * 10^3$, (i.e. there is a single problem for each device thread), and each problem needs and generates two 3-dimensional vectors (the position and velocity) composed of 32-bit floats ($S = 2 * 3 * 4 "bytes" = 24$ bytes), then each transfer into and out of the device would only consist of $N_t S = 120$ KB.  As this is orders-of-magnitude smaller than what is needed for optimal efficiency, each thread of the device could instead operate on $16 "MB" \/ 20 "KB" approx 133$ problems!

// zero-copy memory
If there are indeed multiple problems per device-thread, then zero-copy memory could be used to write a solution to global memory before the thread begins on the next one @cook2012cuda.  This way coarse propagation could begin while problems are still being fine-propagated on the device as shown in @img:zero-copy.  That being said, there is no guarantee the solutions needed in the coarse propagation will be written in the order they are needed.

#figure(
  caption: [When only using pinned memory, all data needs to be copied from the host to the device before any computation can begin (top). Using zero-copy memory (bottom) allows for data transfers to happen at the same time as computation.  Sourced from @cudaCppBestPractices.],
  image(
    "images/zero-copy.png",
    width: 80%
  )
) <img:zero-copy>

Overall, transfers can be avoided nearly completely by executing the coarse propagation on the device and distributing the problems to remote machines via RDMA. If problems are distributed, then the transfers would need to use pinned memory to avoid waiting for the CPU.  In any case, the transfer-rate across PCI-E directly depends on the amount of data being transferred, so it's best to saturate not only all available threads on the device, but also the number of problems per thread.  Even with optimally efficient data transfers, the PA is still bottlenecked by its sequential coarse propagation.

=== Host-Host Data Transfers

// intro
As described in @sec:scale, every time this implementation finishes coarse-propagating and creating the subproblems, those problems are distrubuted from the director to a worker nodes over the network.  Not only does there need to be more work done in order to transmit the problems (e.g. the problems need to be converted from structured data to a bit-stream by serialization) but the throughput of networking hardware is much, much slower compared even to PCI-E.

// cluster topology
It has been shown that cluster topology (i.e. how workers are related to each other, not necessarily physically) can have a significant effect on the performance of inter-machine communication @Deng2020.  As such, there are two topologies to consider: the network associated with the physical path any data takes (e.g. all data has to go through the director), and the network of nodes each node can "see".  The former _physical topology_ consists of the tangible material through which electrical impulses are sent such as ethernet cabling.  The latter _logical topology_ encodes the worker that a particular worker can share data.

// example for this cluster
For example, the cluster shown in @diag:cluster_topology was designed to have the worker processes only communicate with the manager process on the same machine.  This is so only the manager would need to send a single batch of data between physical machines to the director.  While this logical topology seems sound, the actual path the data takes (according to the underlying physical topology) may be significantly detrimental to the overall performance of the cluster.  If the software that manages the message passing requires the director to act as an intermediary, then what looks like a straightfoward intra-machine communication in the logical topology between worker and manager actually results in data being transferred from the worker process to the director, then from the director to the manager, and then (after doing nothing at the manager) from the manager back to the director; this is effectively the a star topology as shown in @img:star_topo.

#figure(
  caption: [While a cluster might have the logical form as shown in @diag:cluster_topology, the physical characteristics of the network connections and how the communication management controls the flow of data must still be considered.  It is possible for the physical topology to be a star.  Image sourced from @starNetwork.],
  image(
    "images/StarNetwork.png",
    width: 33%
  )
) <img:star_topo>

// use threads for each device instead of processes
Situations such as these can be mitigated in the future "simply" by only creating manager processes on the compute nodes, and having each device communicate with the host on its own dedicated thread.  This way the device-manager-director trace truly is linear and efficient.  Though, while this idea is simple in description, the implementation to have the manager process control multiple devices on different threads needs more care, but is still reasonable @besard2019prototyping.

// conclusion
While distributed functionality is key to achieving scalability, the inter-process and inter-machine communication overhead is unavoidable, and thus so is its overhead.  As long as care is taken when considering potentially hidden aspects of working with unshared memory spaces, such the physical versus logical topologies, this communication overhead can be minimized.  Additional performance can be gained by minimizing the number of unshared memory spaces in general and opting for shared memory spaces such as multiple threads where no such overhead arises.

== Benchmarks <sec:analysis_benchmarks>

Benchmarks and other performance evaluations are meaningless without the appropriate context into how the data was gathered.  Just as an engineer should include the relevant model of their equipment in their reported data, if the computational scientist wishes their work to be reproducible, such information must be included with the data.  As such, the hardware and software specifications that were used in these experiments is presented in @tab:cluster_spec.  Further specifications on the GPUs that were used is collected in @tab:gpu_spec.  Additionally, inter-node network traffic was routed through a TP-Link TL-SG108 1Gb/s network switch.

#figure(
  caption: [Specifications for each host/node in the used cluster.],
  table(
      columns: 3,
      table.header[][*Director*][*Worker*],
      [Operating System], [Arch Linux (64-bit)], [Arch Linux (64-bit)],
      [Kernel], [6.14.10], [6.14.9],
      [Motherboard], [ASRock B760M], [ASUS H170],
      [CPU], [Intel i7-13700K \ 24 logical cores \@ 5.40 GHz], [Intel i5-6500 \ 4 logical cores \@ 3.60 GHz],
      [GPU], [NVIDIA RTX 3060 Ti \ #linebreak()], [NVIDIA GTX 1660 Super\ NVIDIA GTX 960],
      [Memory], [32 GB \@ 6500 MHz], [16 GB \@ 1600 MHz]
    )
) <tab:cluster_spec>

#figure(
  caption: [Hardware specifications for the GPUs used in this cluster.  /* Data gathered from techpowerup.com/gpu-specs/. */],
  table(
    columns: 4,
    table.header[][*3060*][*1660*][*960*],
    [Cores],                     [4864], [1408], [1024],
    [Streaming Multiprocessors], [38],   [22],   [8],
    [Base Clock (MHz)],          [1410], [1530], [1176],
    [Boost Clock (MHz)],         [1665], [1785], [1201],
    [Memory Clock (Gb/s)],       [14],   [14],   [7],
    [Memory Size (GB)],          [8],    [6],    [4],
    [Memory Bandwidth (GB/s)],   [448],  [336],  [112],
    [FP16, 32, 64 Performance (TFLOPS)],  [16.2, 16.2, 0.253], [10.0, 5.03, 0.157], [N/A, 2.46, 0.077],
    [Compatible CUDA up to],     [8.6], [7.5], [5.2]
  )
) <tab:gpu_spec>

On the software side, the Julia language was used to encode the calculations.  The Julia standard library's Distributed.jl package was used to perform any and all distributed functionality.  Additionally, the CUDA.jl package was used to facilitate the implementation of GPU-based calculations.  The versions of these packages are detailed in @tab:soft_spec.

#figure(
  caption: [The software versions used in the calculations presented in this work.],
  table(
    columns: 4,
    [Julia Runtime], [1.11.5],
    [LLVM], [libLLVM-16.0.6],
    [Distributed.jl], [1.11.0],
    [CUDA.jl], [5.7.3]
  )
) <tab:soft_spec>

// don't have time right now :(
// = Particle Production in Analog Cosmologies
// - Solve the partial differential equation
// - spectral decomposition
// - system of equations $partial_t^2 tilde(theta) - (dot(a) / a) partial_t tilde(theta) - a c^2 k^2 tilde(theta) = 0$ for wavenumber $k <= k_c$

= Conclusion <sec:conclusion>
- Equations of motion can now benefit from parallel solvers.
- Certain problems are well-suited to a divide-and-conquer approach.
- Problems with "doubly parallel" characteristics can leverage both local and distributed parallelism, achieving significant computational efficiency.
- These advancements pave the way for modeling acoustics in expanding volumes.

== Future work & Possible Optimizations <sec:conc_future>
- Krylov enhanced subspaces
- CUDA dynamic parallelism
- Implement with C, Fortran, CUDA, NVSHMEM, MPI
- Make gpu-backend-agnostic with KernelAbstractions.jl
- this physics could be better done with PFASST
- non-dimensionalize everything following @langtangen2016scaling
- use a variable size time discretization algorithm, then base integration of those differences
- Use dynamic parallelism to avoid the cpu having to launch the kernels
- Use dynamic parallelism to even perform the coarse propagation
- Look into effects of cluster topology

#set par(spacing: 1.15em)
#bibliography(
  "bib.bib",
  // full: true,
  style: "american-physics-society"
)
