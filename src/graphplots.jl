using GraphRecipes, Plots, LightGraphs

export plotabm

"""
    plotabm(model::ABM, c [, s]; kwargs...)
Plot the `model` as a graph by providing two **functions** `c, s`.
Both of these functions gain as an input the list of agents `a` at a node of
the model's graph and output a number. `c` returns a number (anything acceptable by
Plots.jl) of the node while `s` returhs the (relative) size of the node.

`s` defaults to `length`. Internally the `graphplot` recipe is used, and thus
all keyword arguments are propagated into this recipe.
"""
function plotabm end

function plotabm(model::ABM, c, s = length; kwargs...)
    N = nodes(model)
    ncolor = zeros(length(N)); weights = copy(ncolor)
    for (i, n) in enumerate(N)
        a = get_node_contents(n, model)
        ncolor[i] = c(a); weights[i] = s(a)
    end

    # Hack until graphplot recipe can actually plot with number and color
    # https://github.com/JuliaPlots/GraphRecipes.jl/issues/108
    mi, ma = extrema(ncolor)
    cgrad(:plasma)
    colors = [cgrad(:plasma)[(co-mi)/(ma-mi)] for co in ncolor]

    graphplot(model.space.graph, node_weights = weights, nodeshape = :circle,
              color = "black", markerstrokecolor = "black", markerstrokewidth=1.5, markercolor = colors; kwargs...)
end
