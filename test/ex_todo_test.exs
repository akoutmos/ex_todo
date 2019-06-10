defmodule ExTodoTest do
  use ExUnit.Case
  doctest ExTodo

  test "greets the world" do
    assert ExTodo.hello() == :world
  end
end
