# define matrix equation to solve to get finite difference coefficients

"""
    centralCoefficients(order :: Int, accuracy :: Int) :: Vector{Float64}

Get coefficients for a central finite difference on an uniformly discretized domain.

Produces a vector of length `2 * floor((order + 1) / 2) - 1 + accuracy`.
"""
function centralCoefficients(order :: Int, accuracy :: Int) :: Vector{Float64}
    # source: https://en.wikipedia.org/wiki/Finite_difference_coefficient#Central_finite_difference
    @assert ispow2(accuracy) "Accuracy is not a power of 2" # accuracy needs to be a power of 2

    p = floor((order + 1) / 2) - 1 + accuracy / 2 # p is the main value for the vander mode matrix

    vandermodeMatrix = [(-p + j)^i for (i, j) in Iterators.product(0:2p, 0:2p)] # matrix to get the coefficients

    sol = zeros(Int, 2p + 1); sol[order + 1] = factorial(order) # solution vector of the matrix equation

    coefficientVector = vandermodeMatrix \ sol # solve the matrix equation using left division 
                                               # i.e. left multiplication of the inverse of the vandermodeMatrix
    return coefficientVector
end

#= TODO: implement algorithm for non-uniform grid using algorithm 6.2 in
@article{LI200529,
title = {General explicit difference formulas for numerical differentiation},
journal = {Journal of Computational and Applied Mathematics},
volume = {183},
number = {1},
pages = {29-52},
year = {2005},
issn = {0377-0427},
doi = {https://doi.org/10.1016/j.cam.2004.12.026},
url = {https://www.sciencedirect.com/science/article/pii/S0377042704006454},
author = {Jianping Li},
keywords = {Numerical differentiation, Explicit finite difference formula, Generalized Vandermonde determinant, Taylor series, Higher derivatives},
abstract = {Through introducing the generalized Vandermonde determinant, the linear algebraic system of a kind of Vandermonde equations is solved analytically by use of the basic properties of this determinant, and then we present general explicit finite difference formulas with arbitrary order accuracy for approximating first and higher derivatives, which are applicable to unequally or equally spaced data. Comparing with other finite difference formulas, the new explicit difference formulas have some important advantages. Basic computer algorithms for the new formulas are given, and numerical results show that the new explicit difference formulas are quite effective for estimating first and higher derivatives of equally and unequally spaced data.}
}
=#

"""
    operator(hubbleVector :: Vector, speed :: Float64, waveNumber :: Float64, accuracy :: Int = 2)

Gives the finite-difference approximated field operator.
"""
function operator(hubbleVector :: Vector, speed :: Float64, waveNumber :: Float64, accuracy :: Int = 2)
# coefficients for a central finite difference
derivative2 = centralCoefficients(2, accuracy) # second derivative coefficients
derivative1 = centralCoefficients(1, accuracy) # first derivative coefficients
derivative0 = zeros(max(length(derivative1), length(derivative2))) # the derivative0 vector is zero everywhere except in the middle where it's 1
derivative0[length(derivative0) - 1 / 2 + 1 |> Int] = 1 # set center element to 1

dissipationVector = 0.5 * hubbleVector

mat = zeros(length(hubbleVector), length(hubbleVector))
coefficientVector = [derivative2 - dissipation * derivative1 - speed^2 * waveNumber^2 * derivative0 for dissipation in dissipationVector]
# TODO: set appropriate indices of mat to values of coefficientVector to get an n-diagonal matrix of time-series finite difference coefficients.
end