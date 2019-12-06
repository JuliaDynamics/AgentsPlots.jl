export plot2D, plot_CA1D, plot_CA2D, plot_CA2Dgif

const colornames = ["blue", "orange", "green", "red", "purple", "brown", "pink",
"gray", "olive", "cyan", "gold", "lime", "teal", "violet", "darkviolet",
"lawngreen", "lightgreen", "navy"]

"""
    plot2D(node_coords::AbstractArray, colors::AbstractArray; kwargs...)

Creates a scatter plot for nodes and their colors

* node_coords: node positions as coordinates
* colors: color of each node

# Keywords

* nodesize=1.0
* markeralpha = nothing
"""
function plot2D(node_coords::AbstractArray, colors::AbstractArray;
                nodesize=1.0, markeralpha=nothing)
  xs = [i[1] for i in node_coords]
  ys = [i[2] for i in node_coords]

  if markeralpha == nothing
    markeralpha = [1.0 for i in node_coords]
  end 

  scatter(xs, ys, legend=false, grid=false, showaxis=false, markersize=nodesize,
    markercolor=colors, markeralpha=markeralpha)
end

"""
    plot2D(data::AbstractDataFrame, status_column::Symbol; kwargs)

Plots the distribution of agents on a 2D grid. Agent positions should be saved
as tuples.

* data: A dataframe output of your simulation.
* status_column: the name of a column that determines category of each agent, so that it is colored differently.

# Keywords

* cc::Dict=Dict() Optionally provide a color name for each unique value in the `status_column`
* nodesize=1.0 size of each node
* t=0 the time step of the simulation to plot.
"""
function plot2D(data, status_column::Symbol; 
                cc::Dict=Dict(), nodesize=1.0, t::Int=0)

  dd = data[data[!, :step] .== t, :]
  unique_types = unique(dd[!, status_column])

  if length(cc) == 0
    for (ind, s) in enumerate(unique_types)
      cc[s] = colornames[ind]
    end
  end

  nodecolors = [cc[i] for i in dd[!, status_column]]

  plot2D(dd[!, :pos], nodecolors, nodesize=nodesize)
end

"""
    plot_CA1D(data; Keywords)

Visualizes data of a 1D cellular automaton.

* `data`: output of `CA1D.ca_run`.

# Keywords

* nodesize=2.0: Size of each cell.
"""
function plot_CA1D(data; nodesize=2.0)

  nrows = size(data, 1)
  nsteps = length(unique(data[!, :step]))
  node_coords = Array{eltype(data[!, :pos])}(undef, nrows)
  for row in 1:nrows
    node_coords[row] = (data[row, :pos][1], nsteps - data[row, :step])
  end

  nodecolors = ["black" for i in 1:nrows]
  markeralpha = [0.01 for i in 1:nrows]
  for row in 1:nrows
    if data[row, :status] == "1"
      markeralpha[row] = 1.0
    end
  end

  plot2D(node_coords, nodecolors, markeralpha=markeralpha)
end

"""
    plot_CA2D(data; kwargs...)

Visualizes data of a 2D cellular automaton.

* `data`: output of `CA2D.ca_run`.

# Keywords

* t::Int=-1 : The time step to be plotted. If -1, all the rows in `data` are used.
* nodesize=2.0
"""
function plot_CA2D(data; t::Int=-1, nodesize=2.0)

  if t > -1
    dd = data[data[!, :step] .== t, :]
  else
    dd = data
  end

  nrows = size(dd, 1)
  nodecolors = ["black" for i in 1:nrows]
  markeralpha = [0.01 for i in 1:nrows]
  for row in 1:nrows
    if dd[row, :status] == "1"
      markeralpha[row] = 1.0
    end
  end

  plot2D(dd[!, :pos], nodecolors, nodesize=nodesize, markeralpha=markeralpha)
end


"""
    plot_CA2Dgif(data; kwargs...)

Create a 2D scatter plot from all `data` and adds a frame to the `anim` animation object. If `anim` is not provided, it creates a new one. Returns an animation object. It can be saved as an animated gif using `AgentsPlots.gif(anim, "filename.gif")`.

* `data`: output of of time-step of `CA2D.ca_run`.

# Keywords

* anim::Animation=Animation() : animation object. If provided, a new frame is added to it.
* nodesize=2.0
"""
function plot_CA2Dgif(data; nodesize=2.0, anim::Animation=Animation())
  p = plot_CA2D(data; nodesize=nodesize)
  frame(anim, p)
  return anim  
end