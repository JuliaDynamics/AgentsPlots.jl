"""
    plotabm(model::ABM{A, <: ContinuousSpace}; ac, as, am, kwargs...)
Plot all agents of the `model` on continuous space by (optionally)
configuring how to plot the agents with keywords `ac, as, am`.

`ac` = agent color, `as` = agent size, `am` = agent marker shape.

These arguments can be constants (numbers, strings, etc.), and then all agents
get the same property. Or, they can be **functions**, that take as input the
list of agents, and output a vector of colors, sizes, or shapes
(anything acceptable by `scatter`).

Defaults: `ac = "#765db4", as = 8, am = :o`. All other keywords are
propatted into `Plots.scatter`.
"""
function plotabm(model::ABM{A, <: ContinuousSpace};
    ac = "#765db4", as = 8, am = :o,
    kwargs...) where {A}
    length(model.space.extend) ≠ 2 && error("Currently only works for 2D. Please contribute 3D!")
    aa = allagents(model)
    colors = typeof(ac) <: Union{String, Tuple, Real} ? ac : [ac(a) for a in aa]
    sizes = typeof(as) <: Real ? as : [as(a) for a in aa]
    mshapes = typeof(am) <: Union{Symbol, String} ? am : [am(a) for a in aa]
    xs = [a.pos[1] for a in aa]
    ys = [a.pos[2] for a in aa]
    e = model.space.extend
    p1 = scatter(
        xs, ys, markercolor=colors, markersize = sizes, markershape = mshapes,
        label = "", markerstrokewidth = 0,
        xlims=(0,e[1]), ylims=(0,e[2]), xgrid=false, ygrid=false, xaxis=false,yaxis=false,
        kwargs...
    )
end
