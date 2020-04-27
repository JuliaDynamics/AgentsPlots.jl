"""
    plotabm(model::ABM{A, <: DiscreteSpace}; ac, as, am, kwargs...)
Plot the `model` (either as a graph or as a grid) by configuring the
plot through the keywords `ac, as, am`, which are **functions**.
They take as input the vector of agents at the current node and output a
color/size/markershape for the marker that will represent the node.

`ac` defaults to a purple color for all nodes,  `as` defaults to `length`,
and `am` to circle.

For `GraphSpace`, the `graphplot` recipe is used, while for `GridSpace` a
normal `scatter` is called. All `kwargs...` are propagated into these functions.
"""
function plotabm(model::ABM{A, <: GraphSpace};
        ac = x -> "#765db4", as = length, am = x -> :circle,
        kwargs...) where {A}

    N = nodes(model)
    ncolor = Vector(undef, length(N))
    weights = zeros(length(N))
    markers = Vector{Symbol}(undef, length(N))
    for (i, n) in enumerate(N)
        a = get_node_agents(n, model)
        ncolor[i] = ac(a)
        weights[i] = as(a)
        markers[i] = am(a)
    end

    graphplot(
        model.space.graph, node_weights = weights, nodeshape = markers, nodecolor = ncolor,
        color = "black", markerstrokecolor = "black", markerstrokewidth=1.5; kwargs...
    )
end
