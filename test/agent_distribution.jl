mutable struct SchellingAgent <: AbstractAgent
  id::Int # The identifier number of the agent
  pos::Tuple{Int,Int} # The x, y location of the agent
  mood::Bool # whether the agent is happy in its node. (true = happy)
  group::Int # The group of the agent,
             # determines mood as it interacts with neighbors
end

function schelling(;numagents=320, griddims=(20, 20), min_to_be_happy=3)
  space = Space(griddims, moore = true)
  properties = Dict(:min_to_be_happy => min_to_be_happy)
  schelling = ABM(SchellingAgent, space; properties = properties, scheduler=random_activation)
  for n in 1:numagents
    agent = SchellingAgent(n, (1,1), false, n < numagents/2 ? 1 : 2)
    add_agent_single!(agent, schelling)
  end
  return schelling
end

@testset "Agent distribution" begin
  model = schelling()
  groupcolor(a) = a.group == 1 ? :blue : :orange
  groupmarker(a) = a.group == 1 ? :circle : :square
  p = plotabm(model; ac = groupcolor, am = groupmarker)
  @test typeof(p) <: AgentsPlots.AbstractPlot
end
