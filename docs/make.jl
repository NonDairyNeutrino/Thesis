using Documenter
using ParticleProduction

makedocs(
    sitename = "ParticleProduction",
    format = Documenter.HTML(),
    modules = [ParticleProduction]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
