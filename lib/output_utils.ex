defmodule ExTodo.OutputUtils do
  @moduledoc """
  This module is used to format strings for STDOUT so that reports are easy
  to read.
  """

  alias Elixir.IO.ANSI

  @doc "Underline the provided text"
  def underline_text(text) do
    ANSI.underline() <> text <> ANSI.reset()
  end

  @doc "Make the provided text green"
  def green_text(text) do
    ANSI.green() <> text <> ANSI.reset()
  end

  @doc "Make the provided text blue"
  def blue_text(text) do
    ANSI.blue() <> text <> ANSI.reset()
  end

  @doc "Make the provided text white"
  def white_text(text) do
    ANSI.white() <> text <> ANSI.reset()
  end

  @doc "Make the provided text red"
  def red_text(text) do
    ANSI.red() <> text <> ANSI.reset()
  end

  @doc "Make the provided text ligth cyan"
  def light_cyan_text(text) do
    ANSI.light_cyan() <> text <> ANSI.reset()
  end

  @doc "Format a string to be of a certain width and have a certain padding"
  def gen_fixed_width_string(value, width, padding \\ 2)

  def gen_fixed_width_string(value, width, padding) when is_integer(value) do
    value
    |> Integer.to_string()
    |> gen_fixed_width_string(width, padding)
  end

  def gen_fixed_width_string(value, width, padding) do
    sub_string_length = width - (padding + 1)

    value
    |> String.slice(0..sub_string_length)
    |> String.pad_trailing(width)
  end
end
