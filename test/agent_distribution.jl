@testset "Agent distribution" begin
  include("schelling_defs.jl")

  model = instantiate()
  properties = [:pos, :mood, :group]
  n = 2  # number of time steps to run the simulation
  data = step!(model, agent_step!, n, properties, when=1:n)

  for s in 1:n
    @test plot2D(data, :group, nodesize=10.0, s=s, savename="2d-test-$s") != false
  end
end