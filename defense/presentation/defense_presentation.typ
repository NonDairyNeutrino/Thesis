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

== The Main Issue

#tblock()[Calculations take time...]

== The Main Issue

#tblock()[Calculations take time...and we only have so much.]

== The Future is Parallel

- Total runtime = $"time" / "calculation" * "number of calculations"$

- Total runtime #sym.arrow.b $<==> "time" / "calculation"$ #sym.arrow.b or $"calculation" / "time" arrow.t$

== The Future is Parallel

- Total runtime = $"time" / "calculation" * "number of calculations"$

- Total runtime #sym.arrow.b $<==> underbrace("time" / "calculation", "Sequential")$ #sym.arrow.b or $underbrace("calculation" / "time", "Parallel") arrow.t$

// maybe add a image comparing a narrow fast river (single threaded CPU), a slightly wider fast river, and a wide river that's only made of coffee (multithreaded GPU)

== The Future is Parallel

- Total runtime = $"time" / "calculation" * "number of calculations"$

- Total runtime #sym.arrow.b $<==> underbrace("time" / "calculation", "Sequential")$ #sym.arrow.b or $underbrace("calculations" / "time", "Parallel") arrow.t$

- Hardware improvements $=> "time" / "calculation" arrow.b$, but it's decelerating

- More hardware $=> "calculation" / "time" arrow.t$, and it's accelerating

== The Future is Parallel

#tblock()[#align(center, [Parallel algorithms need to be the focus])]

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
