using Plots

function plotabm(
    model::ABM{A,<:GridSpace};
    ac = "#765db4",
    as = 10,
    am = :circle,
    kwargs...,
) where {A}

    aa = allagents(model)
    colors = typeof(ac) <: Union{String,Tuple,Real} ? ac : [ac(a) for a in aa]
    sizes = typeof(as) <: Real ? as : [as(a) for a in aa]
    mshapes = typeof(am) <: Union{Symbol,String} ? am : [am(a) for a in aa]
    pos = [a.pos for a in aa]

    scatter(
        pos;
        markercolor = colors,
        markersize = sizes,
        markershapes = mshapes,
        label = "",
        kwargs...,
    )
end

