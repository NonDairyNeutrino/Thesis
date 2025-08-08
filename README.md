# Scalable Parallel-in-Time Integration for Equations of Motion

The work here, using the functionality of [PararealGPU.jl](https://github.com/nondairyneutrino/PararealGPU.jl), is part of my master's thesis in computational science, finished August 2025.

## Abstract

  Physical simulations always need to balance accuracy and run-time.
  This work implements the Parareal Algorithm using graphics processing units across a distributed system to accurately simulate time-dependent physics while attempting to minimize runtime.
  Data-transfer latency is identified as the primary bottleneck, for which mitigation methods are provided.
  Benchmarks comparing single-threaded, single-GPU, and distributed implementations on a logarithmic spectrum of coarse and fine discretizations are provided.
