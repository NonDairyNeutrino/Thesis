#=
Objective: Core functionality of thesis
Author: Nathan Chapman
=#

using DifferentialEquations
using FFTW

function defineParameters()

    parametersExplicit = (
        boxLength = 10^2,
        m = 1,
        hbar = 1,
        initialParticleNumber = 10^7,
        initialNonlinearity = 10^5,
        nonDimTimeScale = 5 * 10^5,
        timeFinal = 1,
        scalingFunction = (labTime, timeScale -> exp(-labTime / timeScale))
    )

    parametersImplicit = (
        universe = # TODO: create grid of points on which to evaluate
        timeScale = parametersExplicit.nonDimTimeScale * (parametersExplicit.m * parametersExplicit.boxLength^2) / parametersExplicit.hbar,
        interactionStrength0 = parametersExplicit.initialNonlinearity * parametersExplicit.hbar^2/(parametersExplicit.initialParticleNumber * parametersExplicit.m * parametersExplicit.boxLength^2),
        soundSpeed0 = sqrt(parametersExplicit.initialNonlinearity)
    )

    return parametersExplicit, parametersImplicit
end

function scaling(::Val{"lab"}, timeScale::Real, labTime::Real)
    return parametersExplicit.scalingFunction(labTime, timeScale)
end

function scaling(::Val{"conformal"}, timeScale, conformalTime)
    return (conformalTime / 2timeScale)^2
end

function defineFieldEquation()
    phaseFieldEquation = # TODO: add phaseFieldEquation in DifferentialEquations.jl syntax
    initialConditionVector = {} # TODO: add intial conditions
    return phaseFieldEquation, initialConditionVector
end

# TODO: solve the field phaseFieldEquation
# TODO: use FFT on phase field to get phase amplitudes
# TODO: mix amplitudes
# TODO: calculate particle numbers