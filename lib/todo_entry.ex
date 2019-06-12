defmodule ExTodo.TodoEntry do
  alias __MODULE__

  defstruct ~w(type line comment)a

  def build(type, line, comment) do
    %TodoEntry{
      type: type,
      line: line,
      comment: comment
    }
  end
end
