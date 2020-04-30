"""
    plotabm(model::ABM{A, <: GraphSpace}; ac, as, am, kwargs...)
This function is the same as `plotabm` for `ContinuousSpace`, but here the three key
functions `ac, as, am` do not get an agent as an input but a vector of agents at
each node of the graph. Their output is the same.

Here `as` defaults to `length`. Internally, the `graphplot` recipe is used, and
all other `kwargs...` are propagated there.
"""
function plotabm(model::ABM{A, <: GraphSpace};
        ac = x -> "#765db4", as = length, am = x -> :circle,
        kwargs...) where {A}

    N = nodes(model)
    ncolor = Vector(undef, length(N))
    weights = zeros(length(N))
    markers = Vector(undef, length(N))
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
