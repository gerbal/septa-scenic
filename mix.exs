defmodule ScenicSepta.MixProject do
  use Mix.Project
  @app :scenic_septa

  def project do
    [
      app: @app,
      version: "0.1.0",
      elixir: "~> 1.7",
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # releases: release(),
    ]
  end

  def release do
    [
      scenic_septa: [
        steps:  [
          overwrite: true,
          cookie: "#{@app}_cookie",
          steps: [:assemble, &Bakeware.assemble/1],
          strip_beams: Mix.env() == :prod
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {ScenicSepta, []},
      extra_applications: [:crypto]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:scenic, "~> 0.10"},
      {:scenic_driver_glfw, "~> 0.10", targets: :host},
      {:scenic_clock, "~> 0.10"},
      # {:bakeware, "~> 0.1", runtime: false},
      # {:scenic_live_reload, "~> 0.2", only: :dev}
    ]
  end
end
