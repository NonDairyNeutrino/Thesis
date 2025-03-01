# Scalable Parallel-in-Time Integration for Equations of Motion: Particle Production in Analog Cosmologies

The work here, using the functionality of [Parareal.jl](https://github.com/nondairyneutrino/Parareal.jl) and [PararealGPU.jl](https://github.com/nondairyneutrino/PararealGPU.jl), is part of my master's thesis in computational science, finished June 2025.

## Abstract

Simulating time-dependent physics has traditionally been constrained to using sequential algorithms, thus not benefiting from advances in parallel computing.
Parallel-in-time integration attempts to address this limitation with methods such as the Parareal algorithm.
As the performance of the Parareal algorithm scales with the number of processors, it is well-suited to use the massively-parallel nature of graphics processing units.
Additional performance gains are seen when the physics is wave-like, as using a spectral method allows for each node in a distributed system to evaluate the Parareal algorithm.
Particle production in different cosmologies is used to highlight the performance gains from these methods.

## Outline

[](https://github.com/nondairyneutrino/Thesis/report/manuscript/toc.pdf "@embed")