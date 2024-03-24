# define matrix equation to solve to get finite difference coefficients
p(order :: Int, accuracy :: Int) :: Int = floor((order + 1) / 2) - 1 + accuracy / 2
nCoefficients(order :: Int, accuracy :: Int) :: Int = 2 * p(order, accuracy) + 1

"""
    centralCoefficients(order :: Int, accuracy :: Int) :: Vector{Float64}

Get coefficients for a central finite difference
"""
function centralCoefficients(order :: Int, accuracy :: Int) :: Vector{Float64}
    n = floor((order + 1) / 2) - 1 + accuracy / 2
    mat = [(-n + j)^i for (i, j) in Iterators.product(0:2n, 0:2n)]
    sol = zeros(Int, 2n + 1); sol[order + 1] = factorial(order)
    coefficientVector = mat \ sol
    return coefficientVector
end


