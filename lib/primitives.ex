defmodule ScenicSepta.Primitives do
  alias Scenic.Graph
  alias Scenic.Primitive

  # --------------------------------------------------------
  @doc """
  Add a septagon to a graph.
  septagons are defined by a radius.
  The following example will draw septagon with radius 100.
      graph
      |> septagon( 100 )
  ### Styles
  septagons honor the following styles
  * `:hidden` - If `true`, the outline is rendered. If `false`, it is skipped.
    Default: `false`.
  * `:fill` - Fills in the interior with the specified paint. If not set, the
    default is to not draw anything in the interior. This is similar to specifying
    `fill: :clear`, but more optimized.
  * `:stroke` - The width and paint to draw the outline with. If the stroke is not
    specified, the default stroke is `{1, :white}`.
  Example:
      graph
      |> septagon( 40, fill: :red, stroke: {3, :blue}, translate: {100, 200} )
  While you could apply a `:rotate` transform to a septagon, it wouldn't do
  anything visible unless you also add a uneven `:scale` transform to make it
  into an ellipse.
  """
  @spec septagon(
          source :: Graph.t() | Primitive.t(),
          radius :: number,
          options :: list
        ) :: Graph.t() | Primitive.t()

  def septagon(graph_or_primitive, radius, opts \\ [])

  def septagon(%Graph{} = g, data, opts) do
    add_to_graph(g, Primitives.Septagon, data, opts)
  end

  def septagon(%Primitive{module: _} = p, data, opts) do
    modify(p, data, opts)
  end

  # --------------------------------------------------------
  @doc """
  Create the specification that adds a septagon to a graph.
  See the documentation for `septagon/3` for details.
  Example:
      septagon = septagon_spec( 40, stroke: {4, :blue} )
      graph = septagon.(graph)
  """

  @spec septagon_spec(
          radius :: number,
          options :: list
        ) :: Graph.deferred()

  def septagon_spec(radius, opts \\ []) do
    fn g -> septagon(g, radius, opts) end
  end

  # ============================================================================
  # generic workhorse versions

  defp add_to_graph(%Graph{} = g, mod, data, opts) do
    mod.verify!(data)
    mod.add_to_graph(g, data, opts)
  end

  defp modify(%Primitive{module: mod} = p, data, opts) do
    mod.verify!(data)
    Primitive.put(p, data, opts)
  end
end
