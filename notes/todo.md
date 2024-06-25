This is a list of things I need to get done over the summer to complete the bulk content of my thesis.

# Preliminary Analysis of Field Equation Solution
- Find physical combination of computational parameters (e.g. k_c, initial particle number etc)
- On average, does the solution change slowly?
	- If yes, then time steps don't need to be small
	- If no, then time steps do need to be small
# CPU based Parareal
- Implement the Parareal algorithm for user defined coarse and fine integrators
	- Find references for the Parareal algorithm
# Single GPU Parareal
- Implement the call to the parareal algorithm as a CUDA kernel
	- Probably will need to do manual kernel definition instead of using `cu()`
# Distributed (Multiple) GPU Parareal
- Learn `Distributed` functionality of Julia standard library