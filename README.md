<p align="center">
  <img src="docs/src/images/GeoStats.png" height="280">
  <a href="https://travis-ci.org/juliohm/GeoStats.jl">
    <img src="https://travis-ci.org/juliohm/GeoStats.jl.svg?branch=master">
  </a>
  <a href="http://pkg.julialang.org/?pkg=GeoStats">
    <img src="http://pkg.julialang.org/badges/GeoStats_0.6.svg">
  </a>
  <a href="https://codecov.io/gh/juliohm/GeoStats.jl">
    <img src="https://codecov.io/gh/juliohm/GeoStats.jl/branch/master/graph/badge.svg">
  </a>
  <a href="https://juliohm.github.io/GeoStats.jl/stable">
    <img src="https://img.shields.io/badge/docs-stable-blue.svg">
  </a>
  <a href="https://juliohm.github.io/GeoStats.jl/latest">
    <img src="https://img.shields.io/badge/docs-latest-blue.svg">
  </a>
  <a href="LICENSE">
    <img src="https://img.shields.io/badge/license-ISC-blue.svg">
  </a>
</p>
<p align="center">
  <i>High-performance implementations of geostatistical algorithms for the Julia programming language.</i>
</p>

# Project goals

- Design a comprehensive framework for geostatistics (or spatial statistics) in a modern programming language.
- Address the lack of a platform for scientific comparison of different geostatistical algorithms in the literature.
- Exploit modern hardware aggressively, including GPUs and computer clusters.
- Educate people outside of the field about the existence of geostatistics.

### Related packages

- [GaussianProcesses.jl](https://github.com/STOR-i/GaussianProcesses.jl) &mdash; Gaussian processes
(the method) and Simple Kriging are essentially [two names for the same concept](https://en.wikipedia.org/wiki/Kriging).
The derivation of Kriging estimators, however; does **not** require distributional assumptions. It is a
beautiful coincidence that for multivariate Gaussian distributions, Simple Kriging gives the conditional
expectation. [Matheron](https://en.wikipedia.org/wiki/Georges_Matheron)
and other important geostatisticians have generalized Gaussian processes to more general random fields with
locally-varying mean and for situations where the mean is unknown. GeoStats.jl includes Gaussian processes as
a special case as well as other more practical Kriging variants, see the [Gaussian processes example](examples).

- [MLKernels.jl](https://github.com/trthatcher/MLKernels.jl) &mdash; Spatial structure can be
represented in many different forms: covariance, variogram, correlogram, etc. Variograms are more
general than covariance kernels according to the intrinsically stationary property. This means that
there are variogram models with no covariance counterpart. Furthermore, empirical variograms can be
easily estimated from the data (in various directions) with an efficient procedure. GeoStats.jl treats
variograms as first-class objects, see the [Variogram modeling example](examples).

- [Interpolations.jl](https://github.com/JuliaMath/Interpolations.jl) &mdash; Kriging and Spline interpolation
have different purposes, yet these two methods are sometimes listed as competing alternatives. Kriging estimation
is about minimizing variance (or estimation error), whereas Spline interpolation is about forcedly smooth estimators
derived for *computer visualization*. [Kriging is a generalization of Splines](http://www.sciencedirect.com/science/article/pii/009830048490030X)
in which one has the freedom to customize spatial structure based on data. Besides the estimate itself, Kriging
also provides the variance map as a function of knots configuration.

## Installation

Get the latest stable release with Julia's package manager:

```julia
Pkg.add("GeoStats")
```

## Project organization

The project is split into various packages:

| Package  | Description |
|:--------:| ----------- |
| [GeoStats.jl](https://github.com/juliohm/GeoStats.jl) | Main package containing Kriging-based solvers, and other geostatistical tools. |
| [GeoStatsImages.jl](https://github.com/juliohm/GeoStatsImages.jl) | Training images for multiple-point geostatistical simulation. |
| [GslibIO.jl](https://github.com/juliohm/GslibIO.jl) | Utilities to read/write *extended* GSLIB files. |
| [GeoStatsBase.jl](https://github.com/juliohm/GeoStatsBase.jl) | Base package containing problem and solution specifications (for developers). |
| [GeoStatsDevTools.jl](https://github.com/juliohm/GeoStatsDevTools.jl) | Developer tools for writing new solvers (for developers). |

The main package (i.e. GeoStats.jl) is self-contained, and provides high-performance
Kriging-based estimation/simulation algorithms over arbitrary domains. Other packages
can be installed from the list above for additional functionality.

### Problems and solvers

Solvers for geostatistical problems can be installed separately depending on the application.
They are automatically integrated with GeoStats.jl thanks to Julia's multiple dispatch features.

#### Estimation problems

| Solver | Description | Build | Coverage | References |
|:------:|-------------|-------|----------|------------|
| [Kriging](https://github.com/juliohm/GeoStats.jl/tree/master/src/solvers) | Kriging (SK, OK, UK, EDK) | [![][travis-img]][travis-url] | [![][codecov-img]][codecov-url] | [Matheron 1971](https://books.google.com/books/about/The_Theory_of_Regionalized_Variables_and.html?id=TGhGAAAAYAAJ) |
| [InvDistWeight](https://github.com/juliohm/InverseDistanceWeighting.jl) | Inverse distance weighting | [![](https://travis-ci.org/juliohm/InverseDistanceWeighting.jl.svg?branch=master)](https://travis-ci.org/juliohm/InverseDistanceWeighting.jl) | [![](https://codecov.io/gh/juliohm/InverseDistanceWeighting.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliohm/InverseDistanceWeighting.jl) | [Shepard 1968](https://dl.acm.org/citation.cfm?id=810616) |
| [LocalWeightRegress](https://github.com/juliohm/LocallyWeightedRegression.jl) | Locally weighted regression | [![](https://travis-ci.org/juliohm/LocallyWeightedRegression.jl.svg?branch=master)](https://travis-ci.org/juliohm/LocallyWeightedRegression.jl) | [![](https://codecov.io/gh/juliohm/LocallyWeightedRegression.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliohm/LocallyWeightedRegression.jl) | [Cleveland 1979](http://www.stat.washington.edu/courses/stat527/s13/readings/Cleveland_JASA_1979.pdf) |

#### Simulation problems

All simulation solvers generate realizations in parallel unless otherwise noted.

| Solver | Description | Build | Coverage | References |
|:------:|-------------|-------|----------|------------|
| [SeqGaussSim](https://github.com/juliohm/GeoStats.jl/tree/master/src/solvers) | Sequential Gaussian simulation | [![][travis-img]][travis-url] | [![][codecov-img]][codecov-url] | [Deutsch 1997](https://www.amazon.com/GSLIB-Geostatistical-Software-Library-Geostatistics/dp/0195100158), [Olea 1999](https://www.amazon.com/Geostatistics-Engineers-Earth-Scientists-Ricardo/dp/0792385233) |
| [ImgQuilt](https://github.com/juliohm/ImageQuilting.jl) | Fast 3D image quilting | [![](https://travis-ci.org/juliohm/ImageQuilting.jl.svg?branch=master)](https://travis-ci.org/juliohm/ImageQuilting.jl) | [![](https://codecov.io/gh/juliohm/ImageQuilting.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/juliohm/ImageQuilting.jl) | [Hoffimann 2017](http://www.sciencedirect.com/science/article/pii/S0098300417301139) |

If you are a developer and your solver is not listed above, please open a pull request and we
will be happy to review and add it to the list.
Please check [GeoStatsBase.jl](https://github.com/juliohm/GeoStatsBase.jl) for instructions on
how to write your own solvers and [GeoStatsDevTools.jl](https://github.com/juliohm/GeoStatsDevTools.jl)
for additional developer tools.

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **most recently tagged version of the documentation.**
- [**LATEST**][docs-latest-url] &mdash; *in-development version of the documentation.*

## Examples

A set of Jupyter notebooks demonstrating the current functionality of the package is available
in the [examples](http://nbviewer.jupyter.org/github/juliohm/GeoStats.jl/tree/master/examples)
folder. These notebooks are distributed with GeoStats.jl and can be launched locally with
`GeoStats.examples()`.

Below is a quick preview of the high-level API, for the full example, please check
[this notebook](http://nbviewer.jupyter.org/github/juliohm/GeoStats.jl/blob/master/examples/EstimationProblems.ipynb).

```julia
using GeoStats
using Plots

# data.csv:
#    x,    y,       station, precipitation
# 25.0, 25.0,     palo alto,           1.0
# 50.0, 75.0,  redwood city,           0.0
# 75.0, 50.0, mountain view,           1.0

# read spreadsheet file containing spatial data
geodata = readtable("data.csv", coordnames=[:x,:y])

# define spatial domain (e.g. regular grid, point collection)
grid = RegularGrid{Float64}(100, 100)

# define estimation problem for any data column(s) (e.g. :precipitation)
problem = EstimationProblem(geodata, grid, :precipitation)

# solve the problem with any solver
solution = solve(problem, Kriging())

# plot the solution
plot(solution)
```
![EstimationSolution](docs/src/images/EstimationSolution.png)

## Contributing and supporting [![Flattr](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/@juliohm)

Contributions are very welcome, as are feature requests and suggestions. Please
[open an issue](https://github.com/juliohm/GeoStats.jl/issues) if you encounter
any problems or if you have questions. GeoStats.jl was developed as part of
academic research. If you would like to help support the project, please star
the repository and share it with your colleagues.

[travis-img]: https://travis-ci.org/juliohm/GeoStats.jl.svg?branch=master
[travis-url]: https://travis-ci.org/juliohm/GeoStats.jl

[julia-pkg-img]: http://pkg.julialang.org/badges/GeoStats_0.6.svg
[julia-pkg-url]: http://pkg.julialang.org/?pkg=GeoStats

[codecov-img]: https://codecov.io/gh/juliohm/GeoStats.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/juliohm/GeoStats.jl

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://juliohm.github.io/GeoStats.jl/stable

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://juliohm.github.io/GeoStats.jl/latest

[license-img]: https://img.shields.io/badge/license-ISC-blue.svg
[license-url]: LICENSE
