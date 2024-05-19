using OrdinaryDiffEq, Plots

# Parameters
const waveNumber     = 1
const timeScale      = 10
const speedInitial   = 1
const initialEnergy  = 1
const initialDensity = 1
const hbar           = 10

# scaling function
scale(time) = exp(-time/timeScale)
dscale(time) = -exp(-time/timeScale) / timeScale

# Initial Conditions
# phaseInitial and velocityInitial need to be vectors of the same type
phaseInitial = [0.]
velocityInitial = [-initialEnergy * initialDensity / hbar]
tspan = (0.0, 10 * timeScale)

# Define the problem
function fieldEquation(acceleration, velocity, phase, waveNumber, time)
    hubble = dscale(time) / scale(time)
    dispersion2 = speedInitial^2 * waveNumber^2
    acceleration .= hubble * velocity + scale(time) * dispersion2 * phase
end

prob = SecondOrderODEProblem(fieldEquation, velocityInitial, phaseInitial, tspan, waveNumber)
sol  = solve(prob, DPRKN6())

phaseFourier   = sol'[:, 2]
densityFourier = (-hbar / initialEnergy) .* sol'[:, 1]

# plot
plot(
    sol.t, 
    [phaseFourier, densityFourier],
    linewidth = 2, 
    xaxis = "Time", 
    yaxis = "Phase Fourier", 
    label = ["phase" "density"]
)