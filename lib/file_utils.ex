defmodule ExTodo.FileUtils do
  @moduledoc """
  Utililities for deals with files and searching for code tags.
  """

  alias ExTodo.{Config, CodetagEntry}

  @glob_pattern "./**"

  @doc "Get all of the files according to the fileglob"
  def get_all_files(%Config{} = config, file_glob \\ @glob_pattern) do
    file_glob
    |> Path.wildcard(match_dot: true)
    |> Enum.reject(fn entry ->
      path_in_ignore_list?(entry, config.skip_directories) or not_file?(entry) or
        file_in_ignore_list?(entry, config.skip_files)
    end)
  end

  @doc "Read the contents of all the files in the provided list"
  def read_file_list_contents(file_list) do
    file_list
    |> Enum.reduce([], fn file_path, acc ->
      file_path
      |> File.read()
      |> case do
        {:ok, file_contents} ->
          [{file_path, file_contents} | acc]

        {:error, _reason} ->
          acc
      end
    end)
  end

  @doc "Get all of the codetags within the list of files given the config settings"
  def get_file_list_codetags(file_contents_list, %Config{} = config) do
    file_contents_list
    |> Enum.reduce([], fn {file_path, file_contents}, acc ->
      file_contents
      |> String.split("\n")
      |> get_lines_with_codetags(config)
      |> case do
        [] ->
          acc

        codetag_entries ->
          [{file_path, codetag_entries} | acc]
      end
    end)
  end

  defp path_in_ignore_list?(path, skip_directories) do
    Enum.find_value(skip_directories, false, fn skip_directory ->
      String.starts_with?(path, skip_directory)
    end)
  end

  defp file_in_ignore_list?(path, skip_files) do
    Enum.find_value(skip_files, false, fn skip_file ->
      String.ends_with?(path, skip_file)
    end)
  end

  defp not_file?(path), do: not File.regular?(path)

  defp get_lines_with_codetags(file_contents, config) do
    get_lines_with_codetags(file_contents, config, 1, [])
  end

  defp get_lines_with_codetags([], _config, _line_num, acc) do
    Enum.reverse(acc)
  end

  defp get_lines_with_codetags([current_line | tail], config, line_num, acc) do
    fuzzy_match_list =
      config.supported_codetags
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

        [%CodetagEntry{type: original, line: line_num, comment: comment} | acc]
      else
        acc
      end

    get_lines_with_codetags(tail, config, line_num + 1, acc)
  end
end
