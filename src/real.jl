using Plots

"""
    plotabm(model::ABM{A, <: ContinuousSpace}; ac, as, am, kwargs...)
    plotabm(model::ABM{A, <: DiscreteSpace}; ac, as, am, kwargs...)

Plot the `model` as a `scatter`-plot, by configuring the agent shape, color and size
via the keywords `ac, as, am`.
These keywords can be constants, or they can be functions, each accepting an agent
and outputting a valid value for color/shape/size.

The keyword `scheduler = model.scheduler` decides the plotting order of agents
(which matters only if there is overlap).

The keyword `offset` is a function with argument `offest(a::Agent)` and is
valid only for discrete space. It targets scenarios where multiple agents existin within
a gridd cell as it adds an offset (same type as `agent.pos`) to the plotted agent position.

All other keywords are propatted into `Plots.scatter` and the plot is returned.
"""
function plotabm(
        model::ABM{A,<:Union{GridSpace, ContinuousSpace};
        ac = "#765db4",
        as = 10,
        am = :circle,
        scheduler = model.scheduler,
        offset = nothing,
        kwargs...,
    ) where {A}

    ids = scheduler(model)
    colors = typeof(ac) <: Function ? [ac(model[i]) for i in ids] : ac
    sizes  = typeof(as) <: Function ? [as(model[i]) for i in ids] : as
    markers= typeof(am) <: Function ? [am(model[i]) for i in ids] : am
    if offeset == nothing
        pos = [model[i].pos for i in ids]
    else
        pos = [model[i].pos .+ offset(model[i]) for i in ids]
    end

    scatter(
        pos;
        markercolor = colors,
        markersize = sizes,
        markershapes = mshapes,
        label = "",
        markerstrokewidth = 0.5,
        markerstrokecolor = :black,
        kwargs...,
    )
end
