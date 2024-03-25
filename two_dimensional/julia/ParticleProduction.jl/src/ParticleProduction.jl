module ParticleProduction
# Outline
# Get user defined scaling function and other computational parameters
# Create the vector of conformal time elements based on the scaling function
# Define phase coefficients chi[eta] at each conformal time
# Create matrix F of finite-difference coefficients
# Create solution vector of zeros except for the first two elements are defined by initial conditions value and derivative
# Solve the matrix equation F * chi[eta] == 0

include("initialize.jl")
include("conformal.jl")
include("operator.jl")

hubbleVector = conformalTime(labtime -> exp(-labtime), 0.1, 1.0)
operator(hubbleVector, 1., 1., 2) |> display
end
