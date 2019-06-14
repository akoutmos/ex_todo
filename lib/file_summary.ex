defmodule ExTodo.FileSummary do
  @moduledoc """
  This module defines a struct which is used to encapsulate all the information
  for a file that contains code tags
  """

  alias __MODULE__

  defstruct file_path: nil, todo_entries: []

  @doc "Build a file summary sruct"
  def build(file_path, todo_entries) do
    %FileSummary{
      file_path: file_path,
      todo_entries: todo_entries
    }
  end
end
