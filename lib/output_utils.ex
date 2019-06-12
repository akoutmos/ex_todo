defmodule ExTodo.OutputUtils do
  alias Elixir.IO.ANSI

  def underline_text(text) do
    ANSI.underline() <> text <> ANSI.reset()
  end

  def green_text(text) do
    ANSI.green() <> text <> ANSI.reset()
  end

  def blue_text(text) do
    ANSI.blue() <> text <> ANSI.reset()
  end

  def white_text(text) do
    ANSI.white() <> text <> ANSI.reset()
  end

  def light_cyan_text(text) do
    ANSI.light_cyan() <> text <> ANSI.reset()
  end

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
