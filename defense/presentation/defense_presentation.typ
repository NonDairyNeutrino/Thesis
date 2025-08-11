#import "@preview/touying:0.4.2": *
#import "@preview/unify:0.6.0": num
#import "@preview/academic-conf-pre:0.1.0" as theme-aus

#let implies = sym.arrow.long.double

#let s = theme-aus.register(aspect-ratio: "16-9") //4-3, 16-9
#let s = (s.methods.info)(
  self: s,
  title: [Scalable Parallel-in-Time Integration\ for Equations of Motion],
  short-title: [Scalable PinT for EOM],
  subtitle: [],
  author: [Nathaniel W. Chapman],
  date: datetime.today(),
  institution: [Department of Computer Science\ Central Washington University],
)

#let (init, slides, touying-outline, alert, speaker-note, tblock) = utils.methods(s)
#let (slide, empty-slide, title-slide, outline-slide, new-section-slide, ending-slide) = utils.slides(s)

#show: init
#show: slides.with(title-slide: false)

#title-slide(authors: [Nathaniel W. Chapman])
#outline-slide()

= Introduction

== It's About Time

#tblock(title: "The main issue")[Calculations take time...and we only have so much.]

== Minimizing Time

#columns(2, [
- Total runtime =\ $"time" / "calculation" * "number of calculations"$

- Wan to minimize runtime

- Minimizing time / calculation #sym.space #sym.arrow.l.r.double.long Speeding up sequential evaluation

- Maximizing calculations / time #sym.arrow.l.r.double.long Adding more parallelization

#colbreak()

#figure(
  caption: [],
  rect(width: 100%)
  // image(
  //   alt: "",

  // )
)
])
== Parallelizing Time

#columns(2, [
- Physics depends on time and space

- Space has been parallelized

- Time has remained sequential

- Parallel-in-Time integration offers a new avenue to speedup

#colbreak()

#figure(
  caption: [],
  rect(width: 100%)
  // image(
  //   alt: "",

  // )
)
])

== Maximizing Resource Utilization

#columns(2, [
  - Space discretized as much as it can e.g. constrained by CFL

  - Spatial parallelization saturated

  - Remaining cores sit idle

  #colbreak()

#figure(
  caption: [],
  rect(width: 100%)
  // image(
  //   alt: "",

  // )
)
])

== More Threads is Always the Answer

#columns(2, [
  - PinT scales with threads

  - CPUs have \~10 threads

  - GPUs have \~10,000 threads

  - Distributed has $infinity$ threads

  #colbreak()

#figure(
  caption: [],
  rect(width: 100%)
  // image(
  //   alt: "",

  // )
)
])

== This work

- Implement the Parareal Algorithm

- Use GPUs and distributed systems

- Simulate motion

= Background

== Growth of Parallel-in-Time Integration

#columns(2, [
- PinT is growing

- Not a new idea

- More cores #sym.arrow.double more interest

- On track for more growth

#colbreak()

#figure(
  supplement: none,
  caption: [/* The number of papers published using parallel-in-time integration has been growing and even accelerating over the years. */  Image credit: parallel-in-time.org],
  image(
    alt: "Histogram showing the accelerating growth of papers in the field of parallel-in-time integration over the past few decade",
    "images/pint_history.png"
  )
  )
])

== Applications of Parallel-in-Time Integration

#columns(2, [
#v(1fr)
- Applications in many sciences

- *Physics*: E&M, Plasmas, Fluids,\ Materials, Astrophysics

- *Engineering*: Manufacturing

- *Operations*: Optimal control

#v(1fr)
#colbreak()
#v(1fr)

- *Economics*: Game theory,\ Market dynamics

- *Biology*: Animal patterns,\ Blood flow in fish

- *Machine Learning*: Training\ neural networks

#v(1fr)
])

== Methods of Parallel-in-Time Integration

#columns(2, [
- Specialized methods

- *General*: Parareal, PITA,\ PFASST, RIDC

- *Hyperbolic*: ParaDiag, MGRIT

- *Parabolic*: STMG, WRMG

#colbreak()

#figure(
  supplement: none,
  caption: [/* Several parallel-in-time methods have been developed.  Each method aims to address limitations of others as well as providing new approaches in general. */  Image credit: parallel-in-time.org],
  image(
    alt: "",
    "images/pint_methods.png",
    width: 100%
  )
  )
])

== Implementations of Parallel-in-Time Integration

#columns(2, [
- Different languages with different means of parallelism

- *Languages*: Fortran, C, C++, Python

- *Parallelism*: OpenMP, MPI

- *HPC*: Very few

#colbreak()

#figure(
  supplement: none,
  caption: [/* Several parallel-in-time methods have been implemented.  Implementations have been developed in a variety of languages with a variety of approaches to parallelism. \  */Image credit: parallel-in-time.org],
  image(
    alt: "",
    "images/pint_codes.png"
  )
  )
])

== Language of Parallel-in-Time Integration

#columns(2, [
- Traditional HPC languages have been used e.g. C/C++, Fortran

- Python has been used

- Julia has the speed of C with the ease of Python

- Julia natively supports parallel, GPU, and distributed

- PinT should be implemented in Julia

#colbreak()

#figure(
  supplement: none,
  caption: [/* Micro-benchmarks have shown Julia runtimes on par with traditional high-performance languages such as C, Fortran, and Rust.  */Image credit: julialang.org],
  image(
    alt: "",
    "images/benchmarks.svg"
  )
  )
])

== This Contribution to Parallel-in-Time Integration

- *Application*: Physics of motion

- *Method*: Parareal

- *Parallelism*: Distributed GPUs

- *Language*: Julia

= The Parareal Algorithm

== Equations of Motion

#columns(2, [
#v(1fr)

- What is an equation of motion?

- *Physics*: A constraint on the dynamics of an object interacting with its environment

- *Math*: A second-order, hyperbolic, differential equation

- Solution is completely determined by initial values (for classical physics)

#v(1fr)
#colbreak()
#v(1fr)

#align(center, 
  [
    *Ex.* The wave equation $ (partial^2) / (partial t^2) phi.alt - 1 / c^2 nabla^2 phi.alt = 0 $
    \
    *Ex.* Newton's Second Law $ sum harpoon(F) = m harpoon(a) $
  ]
)

#v(1fr)
])

== Traditional Numerical Integration

- Future space only depends on previous space

- Space can be parallelized because we know its previous value

- Time has to be sequential because we don't

#tblock(title: [#align(center, [The discretized 1D wave equation])])[
$
  (phi.alt_(x_j)^(t_(i+1)) - 2 phi.alt_(x_j)^(t_(i)) + phi.alt_(x_j)^(t_(i-1))) / (Delta t^2) 
  = 1/c^2 (phi.alt_(x_(j + 1))^(t_i) - 2 phi.alt_(x_j)^(t_i) + phi.alt_(x_(j - 1))^(t_i)) / (Delta x^2) \
  arrow.double.long phi.alt_j^(i+1) = 
  2 phi.alt_j^(i) - phi.alt_j^(i-1) 
  + ((Delta t) / (c Delta x))^2 (phi.alt_(j + 1)^(i) - 2 phi.alt_(j)^(i) + phi.alt_(j - 1)^(i))
$
]

== The Parareal Algorithm

- What about approximating the future?

- The Parareal Algorithm
  + Make inaccurate prediction sequentially
  + Make accurate predictions in parallel based on those values
  + Correct inaccurate prediction with accurate ones
  + Loop until converged

== The Parareal Algorithm - Prepare the Subproblems

- Use fast, inaccurate, sequential "coarse" solver to approximate solution

#figure(
  // caption: [],
  image(
    alt: "",
    "images/root_solution.png",
    height: 91%
  )
)

== The Parareal Algorithm - Solve the Subproblems

- Use slow, accurate, sequential "fine" solver on each coarse value simultaneously

#figure(
  // caption: [],
  image(
    alt: "",
    "images/parallel_propagation_intermediate.png",
    height: 91%
  )
)

== The Parareal Algorithm - Correct the Coarse Solution

#columns(2, [
#v(1fr)

- Use cheap, inaccurate "coarse" solver but correct each propagation

- Correction term = difference\ between previous iteration's fine and coarse values

- "Fine deviation decreases each\ iteration"

#v(1fr)
#colbreak()
#v(1fr)

$ 
"Literature" \
u_t^i := underbrace(cal(G)(u_(t-1)^i), "predictor") + underbrace(cal(F)(u_(t-1)^(i-1)) - cal(G)(u_(t-1)^(i-1)), "corrector") \
\
u_t^i := underbrace(cal(F)(u_(t-1)^(i-1)), "fine solution") + underbrace(cal(G)(u_(t-1)^i) - cal(G)(u_(t-1)^(i-1)), "deviation")
\ "Alternatively"
$

#v(1fr)
])

== The Parareal Algorithm - Converge the Coarse Solution

#columns(2, [
#v(1fr)

- Keep iterating until coarse solution doesn't change much

- Max iterations = coarse discretization

- Converges to "direct" fine solution

#v(1fr)
#colbreak()
#v(1fr)

#align(center, [Convergence condition])
$ max_(1 <= t <= N-1) |u_t^i - u_t^(i-1)| < epsilon $

#v(1fr)
])

// #figure(
//   caption: [],
//   image(
//     alt: "",
//     "images/Parareal_Animation.gif",
//     height: 98%
//   )
// )

= The Parareal Algorithm at Scale

== GPU Computing

#columns(2, [
#v(1fr)

- Execute the same "kernel" program simultaneously on different data
  - "Add 1 to every element of an array" executes in parallel

- Data copies between GPU and host system
  - Takes a lot of time

#v(1fr)
#colbreak()
#v(1fr)

#figure(
  supplement: none,
  caption: [Image Credit: Wikipedia _CUDA_],
  image(
    alt: "",
    "images/CUDA_processing_flow.png",
    width: 100%
  )
)

#v(1fr)
])

== Parareal on the GPU

#columns(2, [

- Almost identical to running on CPU

- Fine solve #sym.arrow Copy, fine solve, copy

- *Pro:* Can be orders-of-magnitude more accurate in same amount of time!

- *Con:* Copying data takes significant time each iteration!
  - *Fix:* Copy enough and do enough to make it worth it!

#colbreak()

#figure(
  supplement: none,
  caption: [],
  image(
    alt: "",
    "images/parallel_propagation_gpu.png",
    width: 100%
  )
)
])

== Distributed Computing

#columns(2, [ 
#v(1fr)

- Shared memory to unshared memory

- Need to explicitly copy data between processes

- Remote Procedure Calls
  - Heuristic: "Evaluate source code over there"
  - Watch out for references!

- Communicating over network is\ really slow!

#v(1fr)
#colbreak()
#v(1fr)

#figure(
  supplement: none,
  caption: [Image Credit: Wikipedia _Distributed Computing_],
  image(
    alt: "",
    "images/Distributed-parallel.svg",
    width: 60%
  )
)
#v(1fr)
])


== Parareal on the Cluster

#columns(2, [ 
#v(1fr)

- Almost identical to running on GPU

  + Director executes coarse solver

  + Director distributes subproblems to workers

  + Director tells workers to execute fine solver on their GPUs

  + Director requests results

  + Director corrects and loops

- Cluster topology has significant influence!

#v(1fr)
#colbreak()
#v(1fr)

#figure(
  supplement: none,
  caption: [Image Credit: Wikipedia _Star Network_],
  image(
    alt: "",
    "images/StarNetwork.png",
    width: 60%
  )
)
#v(1fr)
])

= Performance Analysis

== Numerical Analysis - Error & Energy Drift

- 

== Numerical Analysis - Stability

- 

== Numerical Analysis - Convergence

- 

== Latency & Data Transfers - Host-Device Transfers

- 

== Latency & Data Transfers - Host-Host Transfers

- 

== Benchmarks - Hardware

- 

== Benchmarks - Single Threaded

- 

== Benchmarks - GPU

- 

== Benchmarks - Distributed

- 

== Benchmarks - Comparison

- 

= Conclusion

== Conclusion

- 

== Future Work

- 

== Acknowledgements

- Dr. Andy Piacsek

- The CWU CS Department

- The CWU Physics Department

== Thank You

#columns(2, [
#v(1fr)

- Thank you for your attention

- This work and its code `PararealGPU.jl` are available on GitHub (#sym.arrow.long) and at\ #link("pararealgpu.computationalphysics.net")

#v(1fr)
#colbreak()
#v(1fr)

#figure(
  // caption: [],
  image(
    alt: "",
    "images/github_qr.png"
  )
)
#v(1fr)
])
// = Blocks
// == Blocks
// A *text block* is an elegant structure for presenting structured data. You can choose to display it using bullets or numbered lists.

// #tblock(title: [Block With Bullets])[
//   - You can choose to display it using bullets.
//   - You can choose to display it using bullets.
//   - You can choose to display it using bullets.
// ]
// #tblock(title: [Block With Numbered Lists])[
//   + You can choose to display it using number list.
//   + You can choose to display it using number list.
//   + You can choose to display it using number list.
// ]

// = Complex Layouts
// == Complex Layouts 1
// #tblock(title: [Complex Layouts])[
//   You can easily use composer or grid func from slide to implement *complex layouts*.
// ]

// #grid(
//   columns: (1fr, 1fr, 1fr),
//   figure(
//     rect(),
//     caption: [This is the test figure],
//   ),
//   figure(
//     rect(),
//     caption: [This is the test figure],
//   ),
//   figure(
//     rect(),
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

