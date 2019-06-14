defmodule Mix.Tasks.Todo do
  @moduledoc false

  use Mix.Task

  alias ExTodo.Config
  alias Mix.Shell.IO

  @shortdoc "Find TODO, FIXME, NOTE, etc throughout your codebase"

  @doc """
  This Mix task generates a ExTodo report of the project.
  """
  def run(_args) do
    result =
      Config.config_file()
      |> load_config_file()
      |> merge_defaults()
      |> ExTodo.CLI.run_report()

    unless result do
      System.at_exit(fn _ ->
        exit({:shutdown, 1})
      end)
    end

    :ok
  end

  defp load_config_file(file) do
    if File.exists?(file) do
      IO.info("ExTodo file found. Loading configuration.")

      {config, _bindings} = Code.eval_file(file)

      config
    else
      IO.info("ExTodo file not found. Using defaults.")

      %{}
    end
  end

  defp merge_defaults(config) do
    Map.merge(Config.config_defaults_as_map(), config)
  end
end
