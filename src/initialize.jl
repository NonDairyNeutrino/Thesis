# define initial parameters for the system

"""
    Explicit(timeFinal, stepSizeTemporal, mass, particleNumberInitial, nonLinearity, timeScaleNonDimensional)

Define the parameters to be used e.g. final time, initial particle number, initial nonlinearity
"""
struct Explicit{T} # where T <: Number
    # TEMPORAL PARAMETERS
    timeFinal               :: T # how long the expansion lasts
    stepSizeTemporal        :: T # how long between each moment in simulation time; MUST EVENLY DIVIDE timeFinal
    # COMPUTATIONAL PARAMETERS
    mass                    :: T
    particleNumberInitial   :: T # number of particles at the start of expansion
    nonLinearity            :: T 
    timeScaleNonDimensional :: T #
end

"""
    Implicit(timeScale, interactionStrengthInitial, speedOfSound)

Define parameters in terms of explicit parameters.
"""
struct Implicit
    timeScale
    interactionStrengthInitial
    speedOfSound
end

# print("Enter Scaling Function: ")
scalingFunction = labTime -> exp(-labTime) #= readline() =#