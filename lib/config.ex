defmodule ExTodo.Config do
  @moduledoc """
  This module defines a struct which houses all the
  configuration data for ex_todo.
  """

  @config_file ".todo.exs"

  alias __MODULE__

  defstruct supported_keywords: ~w(NOTE TODO FIXME HACK BUG),
            keyword_errors: ~w(FIXME BUG),
            skip_files: ~w(),
            skip_directories: ~w(.git _build deps cover docs)

  @doc """
  Get the configuration defaults as a Config struct
  """
  def config_defaults_as_map, do: %Config{}

  @doc """
  Get the configuration defaults as a string
  """
  def config_defaults_as_string do
    config = quote do: unquote(%Config{})

    config
    |> Macro.to_string()
    |> Code.format_string!()
  end

  @doc """
  Get the configuration file name
  """
  def config_file, do: @config_file
end
