using GraphRecipes, Plots, LightGraphs

export plotabm

"""
    plotabm(model::ABM [, c , s]; kwargs...)
Plot the `model` as a graph by providing two optional **functions** `c, s`.
Both of these functions gain as an input the list of agents `a` at a node of
the model's graph and output a number. `c` returns a *color* (anything acceptable by
Plots.jl) of the node while `s` returhs the (relative) size of the node.

`c` defaults to a purple color for all nodes, while `s` defaults to `length`.
Internally the `graphplot` recipe is used, and thus
all keyword arguments are propagated into this recipe.
"""
function plotabm end

function plotabm(model::ABM, c = x -> "#765db4", s = length; kwargs...)
    N = nodes(model)
    ncolor = []; weights = zeros(length(N))
    for (i, n) in enumerate(N)
        a = get_node_contents(n, model)
        push!(ncolor, c(a)); weights[i] = s(a)
    end

    graphplot(model.space.graph, node_weights = weights, nodeshape = :circle, nodecolor = ncolor,
              color = "black", markerstrokecolor = "black", markerstrokewidth=1.5; kwargs...)
end
