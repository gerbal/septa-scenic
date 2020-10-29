defmodule Primitives.Septagon do
  @moduledoc """
  Draw a Septagon on screen.

  A Septagram is composed of 7 trianges with a
  """

  use Scenic.Primitive
  import Scenic.Primitives
  alias Scenic.Graph

  @styles [:hidden, :fill, :stroke, :join, :miter_limit]

  # ============================================================================
  # data verification and serialization

  # --------------------------------------------------------
  @doc false
  def info(data),
    do: """
      #{IO.ANSI.red()}#{__MODULE__} data must be: radius
      #{IO.ANSI.yellow()}Received: #{inspect(data)}
      #{IO.ANSI.default_color()}
    """

  # --------------------------------------------------------
  @doc false
  def verify(data) do
    normalize(data)
    {:ok, data}
  rescue
    _ -> :invalid_data
  end

  # --------------------------------------------------------
  @doc false
  @spec normalize(number()) :: number()
  def normalize(radius) when is_number(radius) do
    radius
  end

  # ============================================================================
  @doc """
  Returns a list of styles recognized by this primitive.
  """
  @spec valid_styles() :: [:hidden | :fill | :stroke]
  def valid_styles(), do: @styles

  # --------------------------------------------------------
  def contains_point?(radius, {xp, yp}) do
    # calc the distance squared fromthe pont to the center
    d_sqr = xp * xp + yp * yp
    # test if less or equal to radius squared
    d_sqr <= radius * radius
  end

  # def build(data, opts) do

  # end

  # # def add_to_graph(graph, data \\ nil, opts \\ [])

  def add_to_graph(graph, radius, opts) do
    #   # IO.inspect(data, label: :data)
    #   # IO.inspect(opts, label: :opts)
    # max_size of

    graph =
      graph
      |> group(
        fn group ->
          Enum.reduce(0..6, group, fn i, g ->
            rotation = i * 2 * :math.pi() / 7

            approx_triangle(g, radius, rotation, opts)

          end)
          |> text("7",
            fill: :white,
            font_size: radius * 2,
            text_align: :center_middle,
            translate: {0, radius * 0.1}
          )
        end,
        opts
      )

    Graph.add(graph, __MODULE__, radius, opts)
  end

  def approx_triangle(graph, radius, rotation, opts) do
    b_length = radius

    a_loc = {0, 0}

    # in radians
    b_angle = :math.pi() * (5 / 14)
    a_angle = :math.pi() * (4 / 14)

    a_length = b_length * :math.sin(a_angle) / :math.sin(b_angle)

    tri_height = :math.sqrt(:math.pow(radius, 2) - :math.pow(0.5 * a_length, 2))

    b_loc = {-0.5 * a_length, tri_height}
    c_loc = {0.5 * a_length, tri_height}

    opts =
      opts
      |> Keyword.drop([:translate, :id])
      |> Keyword.merge(
        rotate: rotation,
        pin: {0, 0}
      )

    triangle(graph, {a_loc, b_loc, c_loc}, opts)
  end
end
