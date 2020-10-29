defmodule ScenicSepta.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Scenic.ViewPort
  alias ScenicSepta.Components.Septagon

  import Scenic.Primitives
  import ScenicSepta.Primitives
  # import Scenic.Components

  @note """
    This is a very simple starter application.

    If you want a more full-on example, please start from:

    mix scenic.new.example
  """

  @text_size 24

  # ============================================================================
  # setup

  # --------------------------------------------------------
  def init(_, opts) do
    # get the width and height of the viewport. This is to demonstrate creating
    # a transparent full-screen rectangle to catch user input
    {:ok, %ViewPort.Status{size: {width, height}}} = ViewPort.info(opts[:viewport])

    # show the version of scenic and the glfw driver
    scenic_ver = Application.spec(:scenic, :vsn) |> to_string()
    glfw_ver = Application.spec(:scenic_driver_glfw, :vsn) |> to_string()

    graph =
      Graph.build(font: :roboto, font_size: @text_size)
      # |> add_specs_to_graph([
      #   # text_spec("scenic: v" <> scenic_ver, translate: {20, 40}),
      #   # text_spec("glfw: v" <> glfw_ver, translate: {20, 40 + @text_size}),
      #   # text_spec(@note, translate: {20, 120}),
      #   # septagon_spec(100, translate: {20, 0}, fill: :red),
      #   # septagon_spec(50, translate: {200, 400}, rotate: :math.pi() * (2 / 14))
      #   # quad_spec(
      #   #   {{0, 100}, {160, 0}, {300, 110}, {200, 260}},
      #   #   id: :quad,
      #   #   fill: {:linear, {0, 0, 400, 400, :yellow, :purple}},
      #   #   stroke: {10, :khaki},
      #   #   translate: {160, 0},
      #   #   scale: 0.3,
      #   #   pin: {0, 0}
      #   # )
      #   # rect_spec({width, height},  fill: :blue),
      # ])
      |> Septagon.add_to_graph(__MODULE__)

    {:ok, graph, push: graph}
  end

  # def handle_input(event, _context, state) do
  #   Logger.info("Received event: #{inspect(event)}")
  #   {:noreply, state}
  # end
end
