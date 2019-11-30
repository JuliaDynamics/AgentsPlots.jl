export visualize_2D_agent_distribution, visualize_1DCA, visualize_2DCA

nv = Agents.nv

"""
plot_locs(g, dims::Tuple{Integer,Integer,Integer})

Return three arrays for x, y, z coordinates of each node
"""
function node_locs(g, dims::Tuple{Integer,Integer,Integer})
  coords = []
  for nn in 1:nv(g)
    push!(coords, vertex2coord(nn, dims))
  end
  locs_x = [Float64(i[1]) for i in coords]
  locs_y = [Float64(i[2]) for i in coords]
  locs_z = [Float64(i[3]) for i in coords]
  return locs_x, locs_y, locs_z
end
  
"""
plot_locs(g, dims::Tuple{Integer,Integer})

Return arrays for x, y coordinates of each node
"""
function node_locs(g, dims::Tuple{Integer,Integer})
  coords = []
  for nn in 1:nv(g)
    push!(coords, vertex2coord(nn, dims))
  end
  locs_x = [Float64(i[1]) for i in coords]
  locs_y = [Float64(i[2]) for i in coords]
  return locs_x, locs_y
end

function node_locs(nnodes::Integer, dims::Tuple{Integer,Integer})
  coords = []
  for nn in 1:nnodes
    push!(coords, vertex2coord(nn, dims))
  end
  locs_x = [Float64(i[1]) for i in coords]
  locs_y = [Float64(i[2]) for i in coords]
  return locs_x, locs_y
end

"""
colorrgb(color_names::Array)
Returns a dictionary of each colorname and its RGB values. See colors and names on [list of colors on Wikipedia](https://en.wikipedia.org/wiki/Lists_of_colors)
"""
function colorrgb(color_names::Array)
  script_path = splitdir(realpath(@__FILE__))[1]
  f = joinpath(script_path, "color_names.csv")
  rgb_dict = Dict{AbstractString, Tuple}()
  for row in eachline(f) 
    fields = split(strip(row), ",")
    if fields[1] in color_names || fields[2] in color_names
      rgb_dict[fields[1]] = (parse(Int, fields[4])/256, parse(Int, fields[5])/256, parse(Int, fields[6])/256)
    end
  end
  if length(rgb_dict) < length(color_names)
    simm = intersect(keys(rgb_dict), color_names)
    for ss in keys(rgb_dict)
      if !in(ss, color_names)
        println("$ss is not a valid color name!")
      end
    end
    throw("Provide valid colornames.")
  end
  return rgb_dict
end

"""
colornames(n::Integer)

Returns n random colors as a dictionary (Dict{colorname=>rgb})
"""
function colorrgb(n::Integer)
  script_path = splitdir(realpath(@__FILE__))[1]
  f = joinpath(script_path, "color_names.csv")
  randcolors = rand(1:866, n)  # 866 is the number of colors in the file above
  rgb_dict = Dict{AbstractString, Tuple}()
  for (index,row) in enumerate(eachline(f)) 
    if index in randcolors
      fields = split(strip(row), ",")
      rgb_dict[fields[1]] = (parse(Int, fields[4])/256, parse(Int, fields[5])/256, parse(Int, fields[6])/256)
    end
  end
  return rgb_dict
end

"""
Plots the distribution of agents on a 2D grid.

Plots are saved as PDF files under the name given by the `savename` argument. Optionally, choose a path to save the plots using the `saveloc` argument. The default behavior is to save in the current directory, where the code is run.

* You should provide `position_column` which is the name of the column that holds agent positions.
* If agents have different types and you want each type to be a different color, provide types=<column name>. Use a dictionary (the `cc` argument) to pass colors for each type. You may choose any color name from the [list of colors on Wikipedia](https://en.wikipedia.org/wiki/Lists_of_colors).
"""
function visualize_2D_agent_distribution(data, model::ABM, position_column::Symbol; types::Symbol=:id, savename::AbstractString="2D_agent_distribution", saveloc::AbstractString="./", cc::Dict=Dict(), saveformat::String="pdf")
  g = model.space.graph
  locs_x, locs_y, = node_locs(g, model.space.dimensions)
  
  # base node color is light grey
  nodefillc = [RGBA(0.1,0.1,0.1,0.1) for i in 1:gridsize(model)]
  nodealphas = [0.1 for i in 1:gridsize(model)]
  
  # change node color given the position of the agents. Automatically uses any columns with names: pos, or pos_{some number}
  # TODO a new plot where the alpha value of a node corresponds to the value of an individual on a node
  if types == :id  # there is only one type
    pos = position_column
    d = by(data, pos, N = pos => length)
    maxval = maximum(d[!, :N])
    nodefillc[d[pos]] .= [RGBA(0.1, 0.1, 0.1) for i in  (d[!, :N] ./ maxval) .- 0.001]
    nodealphas[d[pos]] .= [i for i in  (d[!, :N] ./ maxval) .- 0.001]
  else  # there are different types of agents based on the values of the "types" column
    dd = Agents.dropmissing(data[:, [position_column, types]])
    unique_types = sort(unique(dd[!, types]))
    pos = position_column
    if length(cc) == 0
      colors = colorrgb(length(unique_types))
      colordict = Dict{Any, Tuple}()
      colorvalues = collect(values(colors))
      for ut in 1:length(unique_types)
        colordict[unique_types[ut]] = colorvalues[ut]
      end
    else
      colors = colorrgb(collect(values(cc)))
      colordict = Dict{Any, Tuple}()
      for key in keys(cc)
        colordict[key] = colors[cc[key]]
      end
    end
    colorrev = Dict(v=>k for (k,v) in colors)
    for index in 1:length(unique_types)
      tt = unique_types[index]
      d = Agents.by(dd[dd[!, types] .== tt, :], pos, N = pos => length)
      maxval = maximum(d[!, :N])
      nodefillc[d[!, pos]] .= [RGBA(colordict[tt][1], colordict[tt][2], colordict[tt][3]) for i in  (d[!, :N] ./ maxval) .- 0.001]
      nodealphas[d[!, pos]] .= [i for i in  (d[!, :N] ./ maxval) .- 0.001]
      println("$tt: $(colorrev[colordict[tt]])")
    end
  end
  
  NODESIZE = 0.45*sqrt(gridsize(model))
  scatter(locs_x, locs_y, legend=false, grid=false, showaxis=false, markersize=NODESIZE, markerstrokestyle = :square, markercolor=nodefillc, markeralpha=nodealphas)
  savefig(joinpath(saveloc, "$savename.$saveformat"))
end

"""
    visualize_1DCA(data, model::ABM, runs::Integer; kwargs...)

Visualizes data of a 1D cellular automaton and saves it in a PDF file under the name given by the `savename` argument. Optionally provide a location for the plots to be saved using the `saveloc` argument. The default behavior is to save them in the currently active directory.

* `data` are the result of multiple runs of the simulation.
* `run` is the number of times the model was run.

# Keywords

* position_column::Symbol = :pos : the field of the agent that holds their position.
* status_column::Symbol = :status : the field of the agents that holds their status.
* savename::AbstractString = "CA_1D"
* saveloc::AbstractString = "./"
* saveformat::String="pdf"

"""
function visualize_1DCA(data, model::ABM, runs::Integer;
  position_column::Symbol = :pos,
  status_column::Symbol = :status, savename::AbstractString = "CA_1D",
  saveloc::AbstractString = "./", saveformat::String="png")

  dims = (runs, model.space.dimensions[1])
  nnodes = dims[1]*dims[2]

  # base node color is light grey
  nodefillc = ["black" for i in 1:nnodes];
  nodealphas = zeros(nnodes);
  
  mm = zeros(Int, dims[2], dims[1]+1);
  for r in 0:runs
    d = parse.(Int, sort(data[data[!, :step] .== r, [position_column, status_column]], position_column)[!, status_column])
    mm[:, r+1] = d
  end

  ons = findall(x->x==1, mm);
  ons = getproperty.(ons, :I)
  on_inds = [coord2vertex(i, dims) for i in ons]
  nodealphas[on_inds] .= 1.0
  
  locs_x, locs_y = node_locs(nnodes, dims)
  locs_x = maximum(locs_x) .- locs_x

  NODESIZE = 0.17*sqrt(nv(model))

  scatter(locs_y, locs_x, legend=false, grid=false, showaxis=false, markersize=NODESIZE, markerstrokestyle = :square, markercolor=nodefillc, markeralpha=nodealphas)
  savefig(joinpath(saveloc, "$savename.$saveformat"))  
end

"""
visualize_2DCA(data::DataFrame, model::AbstractModel, position_column::Symbol, status_column::Symbol, runs::Integer; savename::AbstractString="CA_2D")

Visualizes data of a 2D cellular automaton and saves it in PNG format under the name given by the `savename` argument. Optionally provide a location for the plots to be saved using the `saveloc` argument. The default behavior is to save them in the currently active directory.

`data` are the result of multiple runs of the simulation. `position_column` is the field of the agent that holds their position. `status_column` is the field of the agents that holds their status. `runs` is the number of times the simulation was run.
"""
function visualize_2DCA(data, model::ABM, position_column::Symbol, status_column::Symbol, runs::Integer; savename::AbstractString="CA_2D", saveloc::AbstractString="./")
  dims = model.space.dimensions
  g = model.space.graph
  locs_x, locs_y = node_locs(g, dims)
  NODESIZE = 0.02*sqrt(gridsize(model))

  pos1 = Symbol(string(position_column)*"_1")

  nodefillc = ["black" for i in 1:gridsize(model)];
  for r in 1:runs
    nodealphas = [0.01 for i in 1:gridsize(model)];
    stat = Symbol(string(status_column)*"_$r")
    nonzeros = findall(a-> a =="1", data[!, stat])
    
    correct_order = sortperm(data[!, pos1])
    
    nodealphas[nonzeros] .= 1.0
    nodealphas = nodealphas[correct_order]
    
    scatter(locs_x, locs_y, legend=false, grid=false, showaxis=false, markersize=NODESIZE, markerstrokestyle = :square, markercolor=nodefillc, markeralpha=nodealphas);
    savefig(joinpath(saveloc, "$(savename)_$r.png"))
  end
end