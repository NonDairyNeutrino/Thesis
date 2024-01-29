include("ConformalTime.jl") # gives conformalTimeVector

# initial conditions
initialConditionValue      = 1
initialConditionDerivative = 1

# initialize solution vector
phaseFourierVector = similar(conformalTimeVector)
initialTimeStep = conformalTimeVector[2] - conformalTimeVector[1]
phaseFourierVector[1] = initialConditionValue
phaseFourierVector[2] = phaseFourierVector[1] + initialConditionDerivative * initialTimeStep # initialize second value with Euler method

# build a matrix of terms determined via a first order accurate backward difference
