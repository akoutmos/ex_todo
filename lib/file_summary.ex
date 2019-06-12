defmodule ExTodo.FileSummary do
  alias __MODULE__

  defstruct file_path: nil, todo_entries: []

  # FIXME: This is a test
  # TODO This is another test
  # HACK: Cool man
  def build(file_path, todo_entries) do
    %FileSummary{
      file_path: file_path,
      todo_entries: todo_entries
    }
  end
end
