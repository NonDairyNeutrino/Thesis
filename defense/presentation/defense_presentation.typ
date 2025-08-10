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
- Total runtime = $"time" / "calculation" * "number of calculations"$

- Minimize runtime by
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

== Background

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
