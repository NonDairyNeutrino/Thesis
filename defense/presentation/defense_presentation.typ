#import "@preview/touying:0.4.2": *
#import "@preview/unify:0.6.0": num
#import "@preview/academic-conf-pre:0.1.0" as theme-aus

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
  caption: [The number of papers published using parallel-in-time integration has been growing and even accelerating over the years.],
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
  caption: [Several parallel-in-time methods have been developed.  Each method aims to address limitations of others as well as providing new approaches in general.],
  image(
    alt: "",
    "images/pint_methods.png"
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
  caption: [Several parallel-in-time methods have been implemented.  Implementations have been developed in a variety of languages with a variety of approaches to parallelism.],
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
  caption: [Several parallel-in-time methods have been implemented.  Implementations have been developed in a variety of languages with a variety of approaches to parallelism.],
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

== Review of Equations of Motion

== The Parareal Algorithm

= The Parareal Algorithm at Scale

== Review of High-Performance Computing

== Parareal on the GPU

== Parareal on Distributed GPUs

= Performance Analysis

== Numerical Analysis

== Latency & Data Transfers

== Benchmarks

= Conclusion

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


#ending-slide(title: [Thanks for Listening.])[
  \
]
