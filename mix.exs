defmodule ExTodo.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_todo,
      version: "0.1.0",
      elixir: "~> 1.7",
      name: "ExTodo",
      source_url: "https://github.com/akoutmos/ex_todo",
      homepage_url: "https://hex.pm/packages/ex_todo",
      description: "A simple utility to find codetags within a project",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      docs: [
        main: "readme",
        extras: ["README.md"]
      ],
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp package() do
    [
      name: "ex_todo",
      files: ~w(lib mix.exs README.md LICENSE CHANGELOG.md),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/akoutmos/ex_todo"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/sample_files"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ex_doc, ">= 0.0.0"}
    ]
  end
end
