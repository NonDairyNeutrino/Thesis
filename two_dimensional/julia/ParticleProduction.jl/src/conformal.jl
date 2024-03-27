# define conformal time
using QuadGK

"""
    conformalTime(scaling :: Function, step :: Float64, finalTime :: Float64) :: Vector{T} where T <: Number

Generate the sequence of conformal time values.
"""
function conformalTime(scaling :: Function, step :: Float64, finalTime :: Float64) :: Vector
    # TODO: implement integration using quadgk(t -> sqrt(scaling(t)), 0, tn) for tn in labTimeVector
    labTimeVector = 0 : step : finalTime
    conformalTimeVector                 = sqrt.(scaling.(labTimeVector)) |> cumsum
    conformalTimeScaledVector           = scaling.(conformalTimeVector)
    conformalTimeScaledDerivativeVector = (conformalTimeScaledVector[2:end] - conformalTimeScaledVector[1:end-1]) ./ (conformalTimeVector[2:end] - conformalTimeVector[1:end-1]) # first order accurate backward difference
    hubbleVector                        = conformalTimeScaledDerivativeVector ./ conformalTimeScaledVector[2:end]
    return hubbleVector
end