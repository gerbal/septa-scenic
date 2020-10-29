defmodule ScenicSepta.Components.Septagon do
  use Scenic.Component, has_children: false

  alias Scenic.ViewPort
  alias Scenic.Graph

  import Scenic.Primitives
  import ScenicSepta.Primitives
  import Scenic.Clock.Components

  require Logger

  @steps 14
  @height 60

  @default_phase_time 12000
  @total_radians :math.pi() * 2
  @step_incr @total_radians / @default_phase_time
  @sm_green {0x00, 0xA6, 0x8C}

  def verify(scene) when is_atom(scene), do: {:ok, scene}
  def verify({scene, _} = data) when is_atom(scene), do: {:ok, data}
  def verify(_), do: :invalid_data

  def init(_current_scene, opts) do
    graph =
      septagon(Graph.build(), 250,
        translate: {300, 300},
        id: :septa,
        fill: @sm_green,
        join: :round,
        stroke: {:math.sqrt(150), @sm_green}
      )

    Process.send_after(self(), :animate, 333)

    step = @total_radians / @default_phase_time

    {:ok, %{graph: graph, step: step}, push: graph}
  end

  def handle_info(:animate, %{step: step} = state) when step < @total_radians do
    graph = Graph.modify(state.graph, :septa, &do_animate(&1, state.step))

    {:noreply, %{state | graph: graph, step: step + @step_incr}, push: graph}
  end

  def handle_info(:animate, state) do
    graph = Graph.modify(state.graph, :septa, &do_animate(&1, 0))

    {:noreply, %{state | graph: graph, step: 0}, push: graph}
  end

  defp do_animate(%{data: data} = septagon, step) do
    Process.send_after(self(), :animate, 333)

    septagon(septagon, data, rotate: step)
  end

  def handle_input(event, _context, state) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, state}
  end
end
