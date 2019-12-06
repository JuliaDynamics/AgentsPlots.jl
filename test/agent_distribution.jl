@testset "Agent distribution" begin
  include("schelling_defs.jl")

  model = instantiate()
  properties = [:pos, :mood, :group]
  n = 2  # number of time steps to run the simulation
  data = step!(model, agent_step!, n, properties, when=1:n)

  for t in 1:n
    @test typeof(plot2D(data, :group, nodesize=10.0, t=t)) <: AgentsPlots.AbstractPlot
  end
end