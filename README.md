# Scalable Parallel-in-Time Integration for Equations of Motion: Particle Production in Analog Cosmologies

The work here, using the functionality of [Parareal.jl](https://github.com/nondairyneutrino/Parareal.jl) and [PararealGPU.jl](https://github.com/nondairyneutrino/PararealGPU.jl), is part of my master's thesis in computational science, finished June 2025.

## Abstract

Simulating time-dependent physics has traditionally been constrained to using sequential algorithms, thus not benefiting from advances in parallel computing.
Parallel-in-time integration attempts to address this limitation with methods such as the Parareal algorithm.
As the performance of the Parareal algorithm scales with the number of processors, it is well-suited to use the massively-parallel nature of graphics processing units.
Additional performance gains are seen when the physics is wave-like, as using a spectral method allows for each node in a distributed system to evaluate the Parareal algorithm.
Particle production in different cosmologies is used to highlight the performance gains from these methods.

# Outline

## 1. Introduction

## 2. Background

### 2.1. Parallel-in-Time Integration (PinT)

#### 2.1.1. Parareal

#### 2.1.2. Multigrid Reduction in Time (MGRIT)

#### 2.1.3. Parallel Full Approximation Scheme in Space and Time (PFASST)

### 2.2. High-Performance Computing

#### 2.2.1. Multi-threading & GPU Computing

#### 2.2.2. Multi-processing & Distributed Computing

### 2.3. Equations of Motion

#### 2.3.1. Differential Equations

#### 2.3.2. Traditional Numerical Methods

### 2.4. Analog Cosmology

#### 2.4.1. BEC Analogs of FLRW Cosmologies

#### 2.4.2. Variable Speed of Sound and Inflation

#### 2.4.3. The Field Equation

#### 2.4.4. Phononic & Free Particle Modes

#### 2.4.5. Initial Conditions

#### 2.4.6. Particle Production

## 3. Methods

### 3.1. The Parareal Algorithm

### 3.2. The Parareal Algorithm at Scale

## 4. Discussion

### 4.1. Numerical Analysis

#### 4.1.1. Convergence

#### 4.1.2. Stability

#### 4.1.3. Error

### 4.2. Algorithm Analysis

#### 4.2.1. Time Complexity

#### 4.2.2. Space Complexity

### 4.3. Benchmarks

## 5. Showcases

### 5.1. Nonlinear ODE: The Pendulum

### 5.2. PDE: The Wave Equation

### 5.3. Particle Production in Analog Cosmologies

## 6. Conclusion

### 6.1. Future work

## Bibliography
