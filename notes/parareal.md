These are notes composing my research in the Parareal algorithm for solving initial value ordinary differential equations in parallel.  The algorithm is a primary focus of the [methods](methods) of my thesis in computational science.
# Context
Include the following elements in [introduction](introduction)
- The following statements are from _ANALYSIS OF THE PARAREAL TIME-PARALLEL
TIME-INTEGRATION METHOD_ by Gander, M., et al
	- The Parareal algorithm is a special case of a multi-grid method in time
	- Additionally, it is also a special case of a multiple shooting method along the time axis
# The Algorithm
## The Problem
- It turns out the problem to be solved with the Parareal algorithm is
	- only a *first* order ODE $\frac{du}{dt} = f(t, u)$
	- on a finite time interval $t \in [t_0, T]$
	- with uniform time discretization $t_{j+1} = t_j + \Delta T; \Delta T = (T - t_0) / N$
- The problem can also represent the one that arises from the discretization of a PDE using the _Method of Lines_.
## How it works
- Use multiple threads (or processes)
0) Zeroth iteration ($k = 0$): Run coarse propagator $\mathcal{C}$ serially over the entire time interval $\{t_j\}$ to get an approximate guess to the solution
   $U_{j+1}^0 = \mathcal{C}(t_j, t_{j+1}, U_j^0)$
1) Run fine propagator $\mathcal{F}$ for each data point calculated in step in coarse solution
2) $k$-th iteration: The **new** $k$ coarse solution at time step $j + 1$ is equal to "the **new** $k$ coarse solution at time step $j$ (i.e. the previous time step of the new coarse solution)" + "the **old** $k - 1$ fine solution at time step $j$" - "the **old**  $k - 1$ coarse solution at time step $j$"
   $U_{j+1}^k = \mathcal{C}(t_j, t_{j+1}, U_j^k) + \mathcal{F}(t_j, t_{j+1}, U_j^{k-1}) - \mathcal{C}(t_j, t_{j+1}, U_j^{k-1})$
3) Loop until stopping criterion is met e.g. change in coarse solution between iterations is under some threshold.
- Parareal should return the same solution as if done sequentially with the fine grained propagator only
- Parareal should converge in a maximum of $N$ iterations, but for any speedup, convergence should happen in many few iterations i.e. $k \ll N$.
- Coarse correction must be done sequentially
# Other
- Lawrence Livermore National Lab is creating the [XBraid](https://computing.llnl.gov/projects/parallel-time-integration-multigrid) project implementing parallel-in-time methods under the multigrid reduction in time (MGRIT)
- ParaExp could be even faster for linear ODEs [source](https://epubs.siam.org/doi/10.1137/110856137)
- It's suggested that the iteration convergence of the base Parareal algorithm highly depends on phase accuracy of the coarse solver