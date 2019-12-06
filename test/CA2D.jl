@testset "CA2D" begin
  using Agents.CA2D
  # 0. Define the rule
  # Rules of Conway's game of life: DSR (Death, Survival, Reproduction).
  # Cells die if the number of their living neighbors are $<D$,
  # survive if the number of their living neighbors are $<=S$,
  # come to life if their living neighbors are as many as $R$.
  rules = (2,3,3)

  # 1. Build the model
  model = CA2D.build_model(rules=rules, dims=(10, 10), Moore=true)  # creates a model where all cells are "0"
  # make some random cells alive
  for i in 1:nv(model)
    if rand() < 0.1
      model.agents[i].status="1"
    end
  end

  # 2. Run the model, collect data, and visualize it 
  runs = 2
  anim = CA2D.ca_run(model, runs, plot_CA2Dgif);

  @test typeof(anim) <: AgentsPlots.Animation

end
