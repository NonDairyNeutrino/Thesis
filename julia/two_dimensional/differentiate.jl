#=
# Objective: Provide functionality to find the numeric derivative at a point with respect to some variable.
# Author: Nathan Chapman
=#

using Test

function differentiate(var, theta, pt, stepSizes; order = 1)
	# define choice of variable to pick out later
	vc = zeros(Int, length(pt))
	vc[var] = 1

	# name events
	eta = pt[1]
	x   = pt[2]
	y   = pt[3]
	z   = pt[4]

	# name steps
	deta = stepSizes[1]
	dx   = stepSizes[2]
	dy   = stepSizes[3]
	dz   = stepSizes[4]

	# define before, now, and after values
	before = theta(eta - vc[1] * deta, x - vc[2] * dx, y - vc[3] * dy, z - vc[4] * dz)
	now    = theta(eta               , x             , y             , z             )
	after  = theta(eta + vc[1] * deta, x + vc[2] * dx, y + vc[3] * dy, z + vc[4] * dz)

	if order == 1
		# Below implements the first order central finite difference method

		# numerator
		numerator = after - before

		# denominator
		denominator = 2 * (vc[1] * deta + vc[2] * dx + vc[3] * dy + vc[4] * dz)

	elseif order == 2
		# Below implements the second order central finite difference method
		numerator = after - 2 * now + before
		denominator = vc[1] * deta + vc[2] * dx + vc[3] * dy + vc[4] * dz

	end

	return numerator / denominator
end

@test (differentiate(1, (t,x,y,z) -> t^2 + x^2 + y^2 + z^2, (1,0,0,0), .1 * [1,1,1,1]) |> Int) == 2

