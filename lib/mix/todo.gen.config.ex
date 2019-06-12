defmodule Mix.Tasks.ExTodo.Gen.Config do
  @moduledoc false

  use Mix.Task

  alias Mix.Shell.IO
  alias ExTodo.Config

  @shortdoc "Creates a .todo.exs config file with defaults"

  @doc """
  This Mix task generates a .todo.exs configuration file
  """
  def run(_args) do
    create_file =
      if File.exists?(Config.config_file()) do
        IO.yes?("An existing ex_todo config file already exists. Overwrite?")
      else
        true
      end

    if create_file do
      create_config_file()

      IO.info("Successfully created .todo.exs file.")
    else
      IO.info("Did not create .todo.exs file.")
    end
  end

  defp create_config_file do
    File.cwd!()
    |> Path.join(Config.config_file())
    |> File.write(Config.config_defaults_as_string())
  end
end
