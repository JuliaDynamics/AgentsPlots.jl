export plot2D, plot_CA1D, plot_CA2D

const colornames = ["blue", "orange", "green", "red", "purple", "brown", "pink", "gray", "olive", "cyan", "gold", "lime", "teal", "violet", "darkviolet", "lawngreen", "lightgreen", "navy"]

"""
    plot2D(node_coords::AbstractArray, colors::AbstractArray; kwargs...)

saves a scatter plot for nodes and their colors

* node_coords: node positions as coordinates
* colors: color of each node

# Keywords

* savename::String
* saveformat::String="png"
* saveloc::String="./"
* nodesize=1.0
* markeralpha = nothing
"""
function plot2D(node_coords::AbstractArray, colors::AbstractArray;
  savename::String, saveformat::String="png", saveloc::String="./", nodesize=1.0, markeralpha=nothing)
  xs = [i[1] for i in node_coords]
  ys = [i[2] for i in node_coords]

  if markeralpha == nothing
    markeralpha = [1.0 for i in node_coords]
  end 

  scatter(xs, ys, legend=false, grid=false, showaxis=false, markersize=nodesize,
    markercolor=colors, markeralpha=markeralpha)
  savefig(joinpath(saveloc, "$savename.$saveformat")) 
end

"""
    plot2D(data::AbstractDataFrame, status_column::Symbol; kwargs)

Plots the distribution of agents on a 2D grid. Agent positions should be saved
as tuples.

* data: A dataframe output of your simulation.
* status_column: the name of a column that determines category of each agent, so that it is colored differently.

Plots are by default saved in the directory that the code is run. See Keywords for changing that.

# Keywords

* cc::Dict=Dict() Optionally provide a color name for each unique value in the `status_column`
* savename::AbstractString = "2D_agent_distribution"
* saveloc::AbstractString = "./",
* saveformat::String = "png"
* nodesize=1.0 size of each node
* s=0 the step of the simulation to plot.
"""
function plot2D(data, status_column::Symbol; 
  cc::Dict=Dict(), savename::AbstractString = "2D_agent_distribution",
  saveloc::AbstractString = "./", saveformat::String = "png", nodesize=1.0, s::Int=0)

  dd = data[data[!, :step] .== s, :]
  unique_types = unique(dd[!, status_column])

  if length(cc) == 0
    for (ind, t) in enumerate(unique_types)
      cc[t] = colornames[ind]
    end
  end

  nodecolors = [cc[i] for i in dd[!, status_column]]

  plot2D(dd[!, :pos], nodecolors, savename=savename, saveloc=saveloc, saveformat=saveformat, nodesize=nodesize)
end

"""
    plot_CA1D(data; Keywords)

Visualizes data of a 1D cellular automaton and saves it to file. Optionally provide a location for the plots to be saved using the `saveloc` argument. The default behavior is to save them in the currently active directory.

* `data` output of `CA1D.ca_run`.

# Keywords

* savename::AbstractString = "CA_1D" Plot name
* saveloc::AbstractString = "./" Optionally provide a location for the plots to be saved
* saveformat::String="png"
* nodesize=2.0
"""
function plot_CA1D(data;
  savename::AbstractString = "CA_1D",
  saveloc::AbstractString = "./", saveformat::String = "png", nodesize=2.0)

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

  plot2D(node_coords, nodecolors, savename=savename, saveloc=saveloc, saveformat=saveformat, nodesize=nodesize, markeralpha=markeralpha)
end

"""
    plot_CA2D(data; kwargs...)

Visualizes data of a 2D cellular automaton and saves them to files. Optionally provide a location for the plots to be saved using the `saveloc` argument. The default behavior is to save them in the currently active directory.

* `data` output of `CA2D.ca_run`.

# Keywords

* savename::AbstractString = "CA_2D" Plot name
* saveloc::AbstractString = "./" Optionally provide a location for the plots to be saved
* saveformat::String="png"
* nodesize=2.0
"""
function plot_CA2D(data;
  savename::AbstractString = "CA_1D",
  saveloc::AbstractString = "./", saveformat::String = "png", nodesize=2.0)

  steps = unique(data[!, :step])
  for ss in steps
    dd = data[data[!, :step] .== ss, :]

    nrows = size(dd, 1)
    nodecolors = ["black" for i in 1:nrows]
    markeralpha = [0.01 for i in 1:nrows]
    for row in 1:nrows
      if dd[row, :status] == "1"
        markeralpha[row] = 1.0
      end
    end

    plot2D(dd[!, :pos], nodecolors, savename=savename*"_$ss", saveloc=saveloc, saveformat=saveformat, nodesize=nodesize, markeralpha=markeralpha)
  end
end
