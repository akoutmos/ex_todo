defmodule ExTodo.CodetagEntry do
  @moduledoc """
  This module defines a struct which contains all the information for a single
  codetag entry.
  """

  alias __MODULE__

  defstruct ~w(type line comment)a

  def build(type, line, comment) do
    %CodetagEntry{
      type: type,
      line: line,
      comment: comment
    }
  end
end
