# define initial parameters for the system

struct parametersExplicit{T} where T <: Number
    # TEMPORAL PARAMETERS
    timeFinal               :: T # how long the expansion lasts
    stepSizeTemporal        :: T # how long between each moment in simulation time; MUST EVENLY DIVIDE timeFinal
    # SPATIAL PARAMETERS
    spaceFinal              :: T # how big the cubical universe is in one direction
    stepSizeSpatial         :: T # how long between each grid point; MUST EVENLY DIVIDE spaceFinal
    # COMPUTATIONAL PARAMETERS
    mass                    :: T
    particleNumberInitial   :: T # number of particles at the start of expansion
    nonLinearity            :: T 
    timeScaleNonDimensional :: T #
end

struct parametersImplicit
    universe
    timeScale
    interactionStrengthInitial
    speedOfSound
    function parametersImplicit(pe :: parametersExplicit)
        universe = collect(1 : pe.spaceFinal / pe.stepSizeSpatial) # TODO: make into grid
    end
end