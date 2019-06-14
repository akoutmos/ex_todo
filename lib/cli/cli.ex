defmodule ExTodo.CLI do
  alias ExTodo.{Config, FileSummary, FileUtils, OutputUtils, CodetagEntry}
  alias Mix.Shell.IO

  def run_report(%Config{} = config) do
    config
    |> FileUtils.get_all_files()
    |> FileUtils.read_file_list_contents()
    |> FileUtils.get_file_list_codetags(config)
    |> Enum.map(fn {path, file_codetags} ->
      FileSummary.build(path, file_codetags)
    end)
    |> Enum.sort(fn entry_1, entry_2 ->
      entry_1.file_path >= entry_2.file_path
    end)
    |> output_report()
    |> output_summary(config)
    |> report_result(config)
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

  defp output_summary(entries, %Config{} = config) do
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
    |> Map.to_list()
    |> Enum.sort(fn {keyword_1, _}, {keyword_2, _} ->
      keyword_1 <= keyword_2
    end)
    |> Enum.each(fn {keyword, count} ->
      if keyword in config.error_codetags do
        type =
          "  #{keyword}"
          |> OutputUtils.gen_fixed_width_string(10, 1)
          |> OutputUtils.red_text()

        count =
          count
          |> OutputUtils.gen_fixed_width_string(10, 1)
          |> OutputUtils.red_text()

        IO.info("#{type}#{count}")
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

    entries
  end

  defp report_result(entries, %Config{} = config) do
    found_errors =
      entries
      |> Enum.map(fn files ->
        files.todo_entries
      end)
      |> List.flatten()
      |> Enum.find_value(false, fn %CodetagEntry{type: type} ->
        type in config.error_codetags
      end)

    not found_errors
  end
end
