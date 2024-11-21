#import "@preview/touying:0.4.2": *
#import "@preview/unify:0.6.0": num
//#import "../themes/aus-beamer.typ" as theme-aus
#import "@preview/academic-conf-pre:0.1.0" as theme-aus
#import "@preview/cades:0.3.0": qr-code
#import "@preview/algo:0.3.3": algo, i, d, comment, code
#import "@preview/xarrow:0.3.1"

#let s = theme-aus.register(aspect-ratio: "16-9") //4-3, 16-9
#let s = (s.methods.info)(
  self: s,
  title: [Scalable Parallel-in-Time Integration],
  short-title: [Scalable Parallel-in-Time Integration],
  subtitle: [Acoustics in Expanding Volumes],
  author: [Nathan Chapman#super[1], and Andy Piacsek#super[2]],
  short-author: [Chapman \& Piacsek],
  date: [Innovations in Computational Acoustics - ASA #datetime.today().year()],
  institution: [#super[1]Department of Computer Science, Central Washington University\ 
                // #super[2]Department of Science \& Engineering, Whatcom Community College\
                #super[2]Department of Physics, Central Washington University]
)
#let semi-transparent-cover(self: none, constructor: rgb, alpha: 85%, body) = {
  cover-with-rect(
    fill: update-alpha(
      constructor: constructor,
      self.page.fill,
      alpha,
    ),
    body,
  )
}

#let (init, slides, touying-outline, alert, speaker-note, tblock) = utils.methods(s)
#let (slide, empty-slide, title-slide, outline-slide, new-section-slide, ending-slide) = utils.slides(s)

// #show link: underline
#show: init
#show: slides.with()

= Introduction
== Work in Progress
- Work in progress

- Should be finished and avavilable in the Spring!

== The Equation of Motion and Causality
- The equations of motion (EoM) are at the heart of physics
#tblock(title: align(center, "The Equations of Motion"))[
  $ sum_i harpoon(F)_i = m harpoon(a) $
]
#pause

- Numerical methods have been sequential to follow causality
#pause

- These methods haven't been able to benefit from parallelism
#pause

- But what if they could?

// == Acoustics in Expanding Volumes
// TODO: add image e.g. maybe a sequence of expanding boxes with changing waves
// TODO: highlight each part of the equation, especially the a term describing the expansion behavior
// - Wave $psi(t, harpoon(x))$ defined by its density $n$ and phase $theta$ with
// $ psi(t, harpoon(x)) = sqrt(n_0 + Delta n(t, harpoon(x))) e^(i(theta_0 + Delta theta(t, harpoon(x)))) $

// - Wave equation for an expanding volume:
// $ partial_t^2 theta - dot(a)/a partial_t theta - a c_0^2 nabla^2 theta = 0 $

// - Spectral decomposition in space: $tilde(theta)_harpoon(k) = cal(F)(Delta theta)(t, harpoon(k))$ for $k < k_c (t)$
// #tblock(title: align(center, [The Field Equation]))[
//   $ partial_t^2 tilde(theta)_harpoon(k) - dot(a)/a partial_t tilde(theta)_harpoon(k) - a c_0^2 k^2 tilde(theta)_harpoon(k) = 0 $
//   $ tilde(theta)_harpoon(k)(0) = tilde(theta)_(harpoon(k) 0) "    " partial_t tilde(theta)_harpoon(k)(0) = -U_0 n_(harpoon(k) 0) \/ h $
// ]

== Acoustics in Expanding Volumes
#align(
  top, 
  [
    Wave $psi(t, harpoon(x))$ defined by its density $n$ and phase $theta$ as
    $ psi(t, harpoon(x)) = sqrt(n_0 + Delta n(t, harpoon(x))) e^(i(theta_0 + Delta theta(t, harpoon(x)))) $
  ]
)

#tblock(
  $ overbrace(partial_t^2 theta - dot(a)/a partial_t theta - a c_0^2 nabla^2 theta = 0, "Wave Equation in Expanding Volume")  $
)

== Acoustics in Expanding Volumes
#align(
  top, 
  [
    Wave $psi(t, harpoon(x))$ defined by its density $n$ and phase $theta$ as
    $ psi(t, harpoon(x)) = sqrt(n_0 + Delta n(t, harpoon(x))) e^(i(theta_0 + Delta theta(t, harpoon(x)))) $
  ]
)

#tblock(
  $ overbrace(partial_t^2 theta - dot(a)/a partial_t theta - a c_0^2 nabla^2 theta = 0, "Wave Equation in Expanding Volume")
  underbrace(limits(arrow.r.double.long)^(tilde(theta)_harpoon(k) = cal(F)(Delta theta)(t, harpoon(k))), "Spectral decomposition")
  $
)

== Acoustics in Expanding Volumes
#align(
  top, 
  [
    Wave $psi(t, harpoon(x))$ defined by its density $n$ and phase $theta$ as
    $ psi(t, harpoon(x)) = sqrt(n_0 + Delta n(t, harpoon(x))) e^(i(theta_0 + Delta theta(t, harpoon(x)))) $
  ]
)

#tblock(
  $ overbrace(partial_t^2 theta - dot(a)/a partial_t theta - a c_0^2 nabla^2 theta = 0, "Wave Equation in Expanding Volume")
  underbrace(limits(arrow.r.double.long)^(tilde(theta)_harpoon(k) = cal(F)(Delta theta)(t, harpoon(k))), "Spectral decomposition")
  overbrace(
    cases(delim: #none,
      partial_t^2 tilde(theta)_harpoon(k) - dot(a)/a partial_t tilde(theta)_harpoon(k) &- a c_0^2 (0)^2 tilde(theta)_harpoon(k) = 0,
      partial_t^2 tilde(theta)_harpoon(k) - dot(a)/a partial_t tilde(theta)_harpoon(k) &- a c_0^2 (1)^2 tilde(theta)_harpoon(k) = 0,
      &dots.v,
      partial_t^2 tilde(theta)_harpoon(k) - dot(a)/a partial_t tilde(theta)_harpoon(k) &- a c_0^2 #hide[\(] k^2 #hide[\)] tilde(theta)_harpoon(k) = 0,
      &dots.v,
      partial_t^2 tilde(theta)_harpoon(k) - dot(a)/a partial_t tilde(theta)_harpoon(k) &- a c_0^2 #hide[\(] k_c^2 #hide[\)] tilde(theta)_harpoon(k) = 0
    ), 
    "ODE for each wave number"
  )
  $
)
Similar to the method of lines
#v(1fr)

= Methods

== Parallel-in-time Integration and the Parareal Algorithm

- "Parallel-in-time integration" #sym.approx "Solving IVP in parallel"
#pause

- Several algorithms
  - Parareal
  - Multigrid Reduction in Time (MGRIT)
  - Parallel Full Approximation Scheme in Space and Time (PFASST)
  - and more
#pause

- The 3 cores steps of the Parareal Algorithm

  + Prepare the subproblems
  + Solve each subproblem in parallel
  + Correct
  + Iterate

== The Parareal Algorithm - Subproblem Preperation

+ Given an initial value problem $P$ 
  $ cal(L)(t, u, partial_t u, partial_t^2 u) = f(t) quad u(0) = u_0, partial_t u(0) = v_0 quad D = \[T, T + Delta T\] $
  #pause

+ Choose number of subproblems $N$ (suggest number of compute cores)
  #pause

+ Partition time domain for $p = 0, 1, dots, N - 1$ 
  $ D = \[T, T + Delta T\] arrow.r D_p = \[T + p / N Delta T, T + (p + 1) / N Delta T\] = [T_p, T_(p + 1)] $
  #pause

+ Choose coarse propagator $cal(C)_0$ to get initial solution values $\{u_p^0\}_p, \{v_p^0\}_p$
  #pause

+  Subproblem  
  $ p equiv cal(L)(dots.c) = f(t) quad 
  underbrace(u(T_p) = u_p^0\, partial_t u(T_i) = v_p^0, "Subproblem initial values") quad 
  underbrace(D_p = \[T_p\, T_(p + 1)\], "Subproblem domain")$

// == The Parareal Algorithm - Subproblem Preperation
// TODO: DIAGRAM OF PREPARING THE SUBPROBLEMS

== The Parareal Algorithm - Parallel Propagation

+ Choose coarse propagator $cal(C)$ 
  - For example, RK2 with a large time-step
#pause

+ Choose fine propagator $cal(F)$ 
  - For example, Velocity-Verlet with a small time-step
#pause

+ On $i$-th iteration, use $cal(C)$ to solve each subproblem $p$ in parallel
  - coarse solution is $cal(C) u_p^i$
#pause

+ Use $cal(F)$ to solve each subproblem $p$ in parallel
  - fine solution is $cal(F) u_p^i$

== The Parareal Algorithm - Corrections

// - What is the Parareal algorithm and how is it useful?
// - Psuedo-code goes here
// - Picture goes here

// TODO: get algo working; addressed in github issue https://github.com/platformer/typst-algorithms/issues/22
// #algo(
//   title: "The Parareal Algorithm",
//   parameters: (
//     [Coarse Propagator $cal(C)$],
//     [Fine Propagator $cal(F)$],
//     [Initial Condition $u_0$],
//     [Discretized Time Domain $T = {T_0, T_1, dots, T_N}$]
//   )
// )[
//   // Output: Solution ${u_0, u_1, ..., u_N}$

//   #comment[INITIALIZATION]\
//   use coarse propagator and initial values to generate ${u_0, u_1, ..., u_N}$ on the discretized time domain $T$\
//   #comment[BEGIN PARALLEL]\
//   #comment[parallelize over the temporal subdomains]\
//   for $n = 0, 1, dots, N - 1$ do #i\
//     Use the fine propagator and psuedo-initial value $u_n$ to get the data point $u_(n + 1)^cal(F)$\
//     Use the coarse propagator and psuedo-initial value $u_n$ to get the data point $u_(n + 1)^cal(C)$\
//     $"corrector"_(n + 1) arrow.l u_(n + 1)^cal(F) - u_(n + 1)^cal(C)$ #d\
// ]


== GPU Computing
- Each subproblem can be computed in parallel on each gpu core

== Distributed Computing
- 1 wave number per gpu
- many machines with gpus can further parallelize the calculation

= Results
== Some Basic Results
- pictures of results

// = Discussion

// == Numerical Analysis
// - Error
// - Convergence
// - Stability

// == Algorithm Analysis
// - Time Complexity
// - Space Complexity

= Conclusion
== Conclusion
// TODO: focus on what I did
- Parallelism is only becoming more accessible

- Parallel-in-time methods like Parareal can be reasonably used
- With parallelism comes scalability onto high-performance platforms

#ending-slide(title: [Thank you for your time.])[
  #v(10%)
  #columns(2,
    [
      - Code available on GitHub #sym.arrow.r.long
      - Let's collaborate! 
      - #link("NChapman@whatcom.edu")
      - #link("nathanwchapman.com")
      #colbreak()
      #qr-code("https://github.com/NonDairyNeutrino/Thesis")
    ]
  )
]

// = Complex Layouts
// == Complex Layouts 1
// #tblock(title: [Complex Layouts])[
//   You can easily use composer or grid func from slide to implement *complex layouts*.
// ]

// #grid(
//   columns: (1fr, 1fr, 1fr),
//   figure(
//     image("figures/grid1.png"),
//     caption: [This is the test figure],
//   ),
//   figure(
//     image("figures/grid2.png"),
//     caption: [This is the test figure],
//   ),
//   figure(
//     image("figures/grid3.png"),
//     caption: [This is the test figure],
//   ),
// )

// == Complex Layouts 2

// #slide(composer: (1.1fr, 1fr))[
//   #set text(0.8em)

//   As you can see, the composer function can be used to create *complex layouts*.

//   And adjust the different layout parameters to achieve the desired result.
// ][
//   #figure(
//     table(
//     columns: 3,
//     align: (center, center, center),
//     [Hello], [Hello], [Hello],
//     [A], [B], [C],
//   ),
//     caption: [This is the table with caption],
//   ) <tab:gateways>
// \

//   #figure(
//     table(
//       columns: 4,
//       [], [Exam 1], [Exam 2], [Exam 3],
//       [John], [85], [96], [86],
//       [Mary], [53], [64], [75],
//       [Robert], [32], [86], [85],
//     ),
//     caption: [This is the table with caption],
//   ) <tab:gateways>
// ]
