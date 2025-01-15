#let title = [Scalable Parallel-in-Time Integration for Equations of Motion:\ Particle Production in Analog Cosmologies]

#set page(
  paper: "us-letter",
  margin: (top: auto, rest: 0.625in),
  numbering: "1",
  header: [Chapman Thesis #h(1fr) #line(length: 100%)]
)
#set par(justify: true)
#set text(font: "New Computer Modern")
#set enum(numbering: "1.a")
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
#align(center)[#text(size: 14pt)[#title]]
#align(center)[Nathaniel Chapman#super[1]]
#align(center)[#super[1]Department of Computer Science, Central Washington University]
#v(18pt)
#align(center)[
  Abstract\
  Abstracty things
]

#outline(indent: auto)
#pagebreak()

= Introduction

== Analog Cosmology

Directly measuring the properties of the universe just after the Big Bang is impossible, as that was almost 14 billion years ago.  Even \emph{indirectly} measuring these properties is extremely difficult via traditional means.  During these brief moments just after the Big Bang, the universe expanded rapidly in a particular way.  During this expansion there were particles popping in and out of existence, each with its own dynamics (e.g. position and momentum).

What is less difficult is cooling down gases to near absolute-zero (about a billion times colder than empty space).  Gases made of certain atoms or molecules have properties that can be changed to almost any value we want.  Because of this, we can turn our knobs in the lab to make the gas behave in a way that matches a certain mathematical model.

For some types of gases, we can choose how strongly the particles in the gas interact with each other.  It turns out that we can choose a certain interaction strength so that the mathematical model that describes how the gas behaves \textbf{exactly} matches the mathematical model of how particles are produced in the universe in the moments just after the Big Bang!  When this happens, we can call this ultra-cold gas an ``analog universe''.

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
#pagebreak()
I choose a gas with linear dispersion, analog massless and spin-0 particles, an analog universe undergoing a de Sitter expansion with zero background velocity.  The de Sitter spacetime is chosen because of its significance to modern cosmology and previously predicted particle production (as done by Hawking) @de_Sitter_inhomogeneities @de_Sitter_particle_production_1 @de_Sitter_particle_production_2. Particle production will be calculated with standard methods @particle_production_1 @particle_production_2.  The numerical parameters chosen in this study also follow from previous studies @parameters.  Computational implementations will be done using high-performance methods.

=== BEC Analogs of FLRW Cosmologies
The gas as is outlined is a ground-state Bose-Einstein condensate (BEC) without thermal or quantum fluctuations. The dynamics of the BEC are described by the Gross-Pitaevskii equation (GPE) under a Bogoliubov mean-field approximation (also known as the #text(style: "italic")[nonlinear Schr\u{00F6}dinger equation]),

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

=== The Field Equation

=== Phononic & Free Particle Modes

=== Initial Conditions

=== Particle Production

== Computational Physics
- Traditional Methods in evoling Equations of Motion
- Def don't use Runge-Kutta methods
- Symplectic Euler
- Velocity Verlet
- etc.

== Parallel-in-Time Integration

- The Parareal Algorithm
- PFASST
- MGRIT

= Methods

== The Parareal Algorithm

== GPU Computing

== Distributed Computing

= Results

== Particle Production

= Discussion

== Physical Implications

== Numerical Analysis

=== Error

=== Convergence

=== Stability

== Algorithm Analysis

=== Time Complexity

=== Space Complexity

== Benchmarks

= Conclusion

#bibliography(
  "bib.bib",
  full: true,
  style: "american-physics-society"
)