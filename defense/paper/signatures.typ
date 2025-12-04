#import "@preview/lovelace:0.3.0": *
#import "@preview/hydra:0.6.1": hydra

#let author = "Nathaniel Wayne Chapman"

#set document(
  title: [title],
  author: "Nathan Chapman"
)
#set page(
  paper: "us-letter",
  margin: 1in,
  header: context {
    let sections = query(selector(heading.where(level: 1)).before(here()))
    // [#here().position()]
    if sections != () {
      [#emph(hydra(1)) #h(1fr) #emph(hydra(2)) #v(-1em) #line(length: 100%)]
    }
  }
)
#set par(justify: false, leading: 2em, spacing: 2em, first-line-indent: 0.5in) // "leading" == "line spacing"
#set text(font: "New Computer Modern", size: 12pt)
#set math.equation(numbering: "(1)", supplement: [Eq.])
#set enum(numbering: "1.1)", full: true)

#set heading(numbering: "1.")
#show heading: set align(center)
#show heading: set block(below: 2em)
#show heading.where(level: 1): it => pagebreak(weak: true) + it
#show heading.where(level: 2): set block(above: 2em)
#show heading.where(level: 3): set block(above: 2em)

#set  outline(depth: 2)
#show outline.entry: set par(leading: 1em)
#show outline.entry.where(level: 1): it => {strong(it)}
#show outline.entry.where(level: 2): set block(below: 1em)

#show figure.caption: set par(leading: 1em)
#show figure.where(kind: "algorithm"): set par(leading: 1em)
#show figure.where(kind: {table}): set par(leading: 1em)

#align(center, [CENTRAL WASHINGTON UNIVERSITY\ Graduate Studies])

#v(1fr)
We hereby approve the thesis of
#align(center, [#author])
Candidate for the degree of Master of Science
#v(1fr)

#align(right, 
table(
  columns: 2,
  stroke: 0pt,
  align: left,
  column-gutter: 1in,
  row-gutter: 0.67in,
  [], [APPROVED FOR THE GRADUATE FACULTY],
  [#line(length: 1.25in)], [#line(length: 100%) #v(-1em) Dr. Andrew Piacsek, Committee Chair #h(1fr)],
  [#line(length: 1.25in)], [#line(length: 100%) #v(-1em) Dr. Michael Braunstein, Committee Member #h(1fr)],
  [#line(length: 1.25in)], [#line(length: 100%) #v(-1em) Dr. Szil$acute(a)$rd VAJDA, Committee Member #h(1fr)],
  [#line(length: 1.25in)], [#line(length: 100%) #v(-1em) Dean of Graduate Studies #h(1fr)],
)
)
#v(1fr)
