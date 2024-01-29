# define scaling and time here for testing purposes
scaling(timeScale, labTime) = exp(- labTime / timeScale) # de Sitter expansion
labTimeVector               = 0 : 0.1 : 1

timeScale                           = 1
conformalTimeVector                 = sqrt.(scaling.(timeScale, labTimeVector)) |> cumsum
conformalTimeScaledVector           = scaling.(timeScale, conformalTimeVector)
conformalTimeScaledDerivativeVector = (conformalTimeScaledVector[2:end] - conformalTimeScaledVector[1:end-1]) ./ (conformalTimeVector[2:end] - conformalTimeVector[1:end-1]) # first order accurate backward difference
hubbleVector                        = conformalTimeScaledDerivativeVector ./ conformalTimeScaledVector[2:end]