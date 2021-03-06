## Copyright (c) 2017, Júlio Hoffimann Mendes <juliohm@stanford.edu>
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

@recipe function f(solution::EstimationSolution{<:RegularGrid};
                   variables=nothing, contour=true)
  # grid dimension and size
  sdomain = domain(solution)
  dim = ndims(sdomain)
  sz  = size(sdomain)
  or  = origin(sdomain)
  sp  = spacing(sdomain)

  # valid variables
  validvars = sort(collect(keys(solution.mean)))

  # plot all variables by default
  variables == nothing && (variables = validvars)
  @assert variables ⊆ validvars "invalid variable name"

  # plot layout: mean and variance for each variable
  layout := (length(variables), 2)

  # contour type for 2D solutions
  contourtype = contour == true ? :contourf : :heatmap

  for (i,var) in enumerate(variables)
    # results in grid format
    M = reshape(solution.mean[var], sz)
    V = reshape(solution.variance[var], sz)

    if dim == 1 # plot a line
      x = or[1]:sp[1]:or[1]+(sz[1]-1)*sp[1]
      @series begin
        subplot := 2i - 1
        seriestype := :path
        legend := false
        title --> string(var, " mean")
        x, M
      end
      @series begin
        subplot := 2i
        seriestype := :path
        legend := false
        title --> string(var, " variance")
        x, V
      end
    elseif dim == 2 # plot a heat map
      @series begin
        subplot := 2i - 1
        seriestype := contourtype
        seriescolor --> :bluesreds
        title --> string(var, " mean")
        flipdim(rotr90(M), 2)
      end
      @series begin
        subplot := 2i
        seriestype := contourtype
        seriescolor --> :bluesreds
        title --> string(var, " variance")
        flipdim(rotr90(V), 2)
      end
    elseif dim == 3 # plot a volume
      @series begin
        subplot := 2i - 1
        seriestype := :volume
        seriescolor --> :bluesreds
        title --> string(var, " mean")
        M
      end
      @series begin
        subplot := 2i
        seriestype := :volume
        seriescolor --> :bluesreds
        title --> string(var, " variance")
        V
      end
    else
      error("cannot plot solution in more than 3 dimensions")
    end
  end
end
