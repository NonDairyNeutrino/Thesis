#import "@preview/touying:0.4.2": *
#import "@preview/unify:0.6.0": num
//#import "../themes/aus-beamer.typ" as theme-aus
#import "@preview/academic-conf-pre:0.1.0" as theme-aus
#import "@preview/cades:0.3.0": qr-code
#import "@preview/algo:0.3.3": algo, i, d, comment, code

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

#let (init, slides, touying-outline, alert, speaker-note, tblock) = utils.methods(s)
#let (slide, empty-slide, title-slide, outline-slide, new-section-slide, ending-slide) = utils.slides(s)

// #show link: underline
#show: init
#show: slides.with()

= Introduction
== Work in Progress
- This is a work in progress
- Should be finished and avavilable in the Spring!
== The Equation of Motion and Causality
// - IVPs can take a long time
// - Parallelization is only becoming more accessible in many ways
//   - Hardware
//   - Effort
//   - Methods and types of problems
// - Work in Progress

- The equations of motion (EoM) is at the heart of physics
#pause
- Motion is causal
#pause
- Methods of solving the EoM have been sequential
#pause
- Calculations haven't been able to benefit from parallelism
#pause
- What if they could?

== Acoustics in Expanding Volumes

// TODO: add image e.g. maybe a sequence of expanding boxes with changing waves
// TODO: highlight each part of the equation, especially the a term describing the expansion behavior
- Wave $psi(t, bold(x))$ defined by its density $n$ and phase $theta$ with
$ psi(t, bold(x)) = sqrt(n_0 + Delta n(t, bold(x))) e^(i(theta_0 + Delta theta(t, bold(x)))) $

- Wave equation for an expanding volume:
$ partial_t^2 theta - dot(a)/a partial_t theta - a c_0^2 nabla^2 theta = 0 $

- Spectral decomposition in space: $tilde(theta)_bold(k) = cal(F)(Delta theta)(t, bold(k))$ for $k < k_c (t)$
#tblock(title: align(center, [The Field Equation]))[
  $ partial_t^2 tilde(theta)_bold(k) - dot(a)/a partial_t tilde(theta)_bold(k) - a c_0^2 k^2 tilde(theta)_bold(k) = 0 $
  $ tilde(theta)_bold(k)(0) = tilde(theta)_(bold(k) 0) "    " partial_t tilde(theta)_bold(k)(0) = -U_0 n_(bold(k) 0) \/ h $
]

== Acoustics in Expanding Volumes

// the combination of the pde and the spectral decomposition yields a system of odes
// #align(center, [DIAGRAM WITH MATH GOES HERE])

$ partial_t^2 theta - dot(a)/a partial_t theta - a c_0^2 nabla^2 theta = 0 
limits(arrow.r.double.long)^(tilde(theta)_bold(k) = cal(F)(Delta theta)(t, bold(k)))
$

= Methods

== The Parareal Algorithm

The 3 cores steps of the Parareal Algorithm

+ Prepare the subproblems
+ Propagate each subproblem in parallel
+ Correct

== The Parareal Algorithm - Subproblem Preperation

#columns(2, [
  + Choose number of subproblems\
    (Suggest number of cores)
  + 
])

== The Parareal Algorithm - Parallel Propagation

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

= Discussion

== Numerical Analysis
- Error
- Convergence
- Stability

== Algorithm Analysis
- Time Complexity
- Space Complexity

= Conclusion
== Conclusion
// TODO: focus on what I did
- Accessibility to parallelization is increasing
- Problems only becoming more complex

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
