using Plots

function plotabm(model::ABM{A, <: GridSpace};
        ac = x -> "#765db4", as = x -> 10, am = x -> :circle,
        kwargs...) where {A}

    D = length(model.space.dimensions)
    N = nodes(model)
    ncolor, weights, markers, pos = [], Float64[], Symbol[], NTuple{D, Int}[]
    for n in N
        a = get_node_agents(n, model)
        isempty(a) && continue
        for (c, f) in zip((ncolor, weights, markers), (ac, as, am))
            push!(c, f(a))
        end
        push!(pos, Agents.vertex2coord(n, model))
    end

    scatter(
        pos; color = ncolor, ms = weights, marker = markers, label = "",
        kwargs...
    )
end
