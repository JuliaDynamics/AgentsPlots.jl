@testset "Agent distribution" begin
  include("schelling_defs.jl")

  model = instantiate()
  properties = [:pos, :mood, :group]
  n = 2  # number of time steps to run the simulation
  data = step!(model, agent_step!, n, properties, when=1:n)

  for i in 1:n
    @test visualize_2D_agent_distribution(data, model, Symbol("pos_$i"), types=Symbol("group_$i"), savename="step_$i", cc=Dict(1=>"blue", 2=>"red")) != false
  end
end