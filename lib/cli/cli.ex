defmodule ExTodo.CLI do
  alias ExTodo.{Config, FileSummary, OutputUtils, TodoEntry}
  alias Mix.Shell.IO

  @glob_pattern "./**"

  def run_report(%Config{} = config) do
    config
    |> get_all_files()
    |> Enum.map(fn file_path ->
      file_path
      |> File.read()
      |> handle_file_read(file_path)
    end)
    |> Enum.reject(fn
      :error -> true
      _ -> false
    end)
    |> Enum.map(fn {:ok, file_contents, path} ->
      file_todos =
        file_contents
        |> String.split("\n")
        |> get_lines_with_todos(config)

      {path, file_todos}
    end)
    |> Enum.reject(fn
      {_path, []} -> true
      _ -> false
    end)
    |> Enum.map(fn {path, file_todos} ->
      FileSummary.build(path, file_todos)
    end)
    |> Enum.sort(fn entry_1, entry_2 ->
      entry_1.file_path >= entry_2.file_path
    end)
    |> output_report()
    |> output_summary(config)
  end

  defp get_all_files(config) do
    @glob_pattern
    |> Path.wildcard(match_dot: true)
    |> Enum.reject(fn entry ->
      path_in_ignore_list?(entry, config.skip_directories) or not_file?(entry)
    end)
  end

  defp path_in_ignore_list?(path, skip_directories) do
    Enum.find_value(skip_directories, false, fn skip_directory ->
      String.starts_with?(path, skip_directory)
    end)
  end

  defp not_file?(path), do: not File.regular?(path)

  defp handle_file_read({:error, reason}, file_path) do
    IO.info("Could not read #{file_path} for reason: #{inspect(reason)}")

    :error
  end

  defp handle_file_read({:ok, file_contents}, path) do
    {:ok, file_contents, path}
  end

  defp get_lines_with_todos(file_contents, config) do
    get_lines_with_todos(file_contents, config, 1, [])
  end

  defp get_lines_with_todos([], _config, _line_num, acc) do
    Enum.reverse(acc)
  end

  defp get_lines_with_todos([current_line | tail], config, line_num, acc) do
    fuzzy_match_list =
      config.supported_keywords
      |> Enum.map(fn keyword ->
        [
          {keyword, "#{keyword}:"},
          {keyword, "#{keyword} :"},
          {keyword, "#{keyword}-"},
          {keyword, "#{keyword} -"},
          {keyword, keyword}
        ]
      end)
      |> List.flatten()

    {original, keyword_in_line} =
      Enum.find(fuzzy_match_list, {:not_found, :not_found}, fn {_original, keyword} ->
        String.contains?(current_line, keyword)
      end)

    acc =
      if keyword_in_line != :not_found do
        comment =
          current_line
          |> String.split(keyword_in_line, parts: 2)
          |> Enum.at(1)
          |> String.trim()

        [%TodoEntry{type: original, line: line_num, comment: comment} | acc]
      else
        acc
      end

    get_lines_with_todos(tail, config, line_num + 1, acc)
  end

  defp output_report([]) do
    IO.info("No codetags of interest have been found in the codebase.")
  end

  defp output_report(entries) do
    Enum.each(entries, fn entry ->
      entry.file_path
      |> OutputUtils.blue_text()
      |> OutputUtils.underline_text()
      |> IO.info()

      Enum.each(entry.todo_entries, fn todo_entry ->
        line_label =
          "  line #{Integer.to_string(todo_entry.line)}"
          |> OutputUtils.gen_fixed_width_string(12, 1)
          |> OutputUtils.green_text()

        type_label =
          todo_entry.type
          |> OutputUtils.gen_fixed_width_string(8, 1)
          |> OutputUtils.white_text()

        comment = OutputUtils.light_cyan_text(todo_entry.comment)

        IO.info("#{line_label}#{type_label}#{comment}")
      end)

      IO.info("")
    end)

    entries
  end

  defp output_summary(entries, config) do
    "ExTodo Scan Summary"
    |> OutputUtils.blue_text()
    |> OutputUtils.underline_text()
    |> IO.info()

    entries
    |> Enum.map(fn files ->
      files.todo_entries
    end)
    |> List.flatten()
    |> Enum.reduce(%{}, fn entry, acc ->
      acc
      |> Map.update(entry.type, 1, &(&1 + 1))
    end)
    |> Enum.each(fn {keyword, count} ->
      if keyword in config.keyword_errors do
        type =
          "  #{keyword}"
          |> OutputUtils.gen_fixed_width_string(10, 1)
          |> OutputUtils.red_text()

        count =
          count
          |> OutputUtils.gen_fixed_width_string(10, 1)
          |> OutputUtils.red_text()

        IO.error("#{type}#{count}")
      else
        type =
          "  #{keyword}"
          |> OutputUtils.gen_fixed_width_string(10, 1)
          |> OutputUtils.green_text()

        count =
          count
          |> OutputUtils.gen_fixed_width_string(10, 1)
          |> OutputUtils.green_text()

        IO.info("#{type}#{count}")
      end
    end)
  end
end
