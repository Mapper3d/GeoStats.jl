## Copyright (c) 2015, Júlio Hoffimann Mendes <juliohm@stanford.edu>
##
## Permission to use, copy, modify, and/or distribute this software for any
## purpose with or without fee is hereby granted, provided that the above
## copyright notice and this permission notice appear in all copies.
##
## THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
## WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
## MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
## ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
## WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
## ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
## OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

__precompile__()

module GeoStats

using Reexport
using Distances
using StatsBase: sample
using Distributions
using Combinatorics: multiexponents
using SpecialFunctions: besselk
using RecipesBase

# won't be needed in Julia v0.7
using Parameters: @with_kw
@reexport using NamedTuples

# export project modules
@reexport using GeoStatsBase
@reexport using GeoStatsDevTools

# extend base module
import GeoStatsBase: digest, solve, solve_single

# utilities
include("distances.jl")
include("distributions.jl")

# variograms and Kriging estimators
include("empirical_variograms.jl")
include("theoretical_variograms.jl")
include("estimators.jl")

# solvers
include("solvers.jl")

# digest solutions
include("solutions/estimation_solution.jl")
include("solutions/simulation_solution.jl")

# solver comparisons
include("comparisons.jl")

# plot recipes
include("plotrecipes/hscatter.jl")
include("plotrecipes/empirical_variograms.jl")
include("plotrecipes/theoretical_variograms.jl")
include("plotrecipes/solutions/estimation_solution.jl")
include("plotrecipes/solutions/simulation_solution.jl")

# helper function to launch examples from Julia prompt
function examples()
  path = joinpath(@__DIR__,"..","examples")
  @eval using IJulia
  @eval notebook(dir=$path)
end

export
  # distances
  Ellipsoidal,
  evaluate,

  # distributions
  EmpiricalDistribution,
  quantile,
  cdf,

  # empirical variograms
  EmpiricalVariogram,

  # theoretical variograms
  GaussianVariogram,
  ExponentialVariogram,
  MaternVariogram,
  SphericalVariogram,
  CubicVariogram,
  PentasphericalVariogram,
  PowerVariogram,
  SineHoleVariogram,
  CompositeVariogram,
  isstationary,

  # Kriging estimators
  SimpleKriging,
  OrdinaryKriging,
  UniversalKriging,
  ExternalDriftKriging,
  fit!,
  weights,
  estimate,

  # solvers
  Kriging,
  SeqGaussSim,

  # solver comparisons
  VisualComparison,
  CrossValidation,
  compare

end # module
