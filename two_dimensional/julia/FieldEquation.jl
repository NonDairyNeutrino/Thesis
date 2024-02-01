using LinearAlgebra, GLMakie

include("ConformalTime.jl") # gives conformalTimeVector

# initial conditions
initialConditionValue      = 1
initialConditionDerivative = 1

# initialize solution vector
phaseFourierVector    = similar(conformalTimeVector)
initialTimeStep       = conformalTimeVector[2] - conformalTimeVector[1]
phaseFourierVector[1] = initialConditionValue
phaseFourierVector[2] = phaseFourierVector[1] + initialConditionDerivative * initialTimeStep # initialize second value with Euler method

# initialize operator matrix
operatorMatrix = zeros(length(conformalTimeVector), length(conformalTimeVector))

# build a matrix of terms determined via a first order accurate central difference
operatorMatrix[1, 1] = 1

speed = 1
wavenumber = 1
for n in 2 : length(conformalTimeVector) - 1
    deta               = conformalTimeVector[n] - conformalTimeVector[n - 1]
    outerCoefficicent  =  1 - 0.25 * hubbleVector[n] * deta
    centralCoefficient = -2 - speed * wavenumber^2 * deta^2

    operatorMatrix[n, n - 1] = outerCoefficicent
    operatorMatrix[n, n]     = centralCoefficient
    operatorMatrix[n, n + 1] = outerCoefficicent
end

phaseFourierVector = nullspace(operatorMatrix) |> vec

# display(operatorMatrix)
# display(phaseFourierVector)

# crude plot
fig = lines(conformalTimeVector, phaseFourierVector)
save("phaseFourier(t).png", fig, axis=(; title="Phase Fourier Transform", xlabel="t"), ylabel="χ")
# display(fig)