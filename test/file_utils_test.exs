defmodule FilUtilsTest do
  use ExUnit.Case

  alias ExTodo.{Config, FileUtils}

  describe "get_all_files/2" do
    test "should return a list of all the files that match the catch all glob" do
      files = get_all_sample_files()

      assert files == [
               "test/sample_files/c_sample.c",
               "test/sample_files/ex_sample.ex",
               "test/sample_files/js/js_sample.js"
             ]
    end

    test "should return a list of all the files that match a certain file glob" do
      files =
        %Config{}
        |> FileUtils.get_all_files("./**/*.c")
        |> Enum.sort()

      assert files == ["test/sample_files/c_sample.c"]
    end

    test "should return a list of all files except the skipped files" do
      files = get_all_sample_files(%Config{skip_patterns: [~r/c_sample\.c/]})

      assert files == [
               "test/sample_files/ex_sample.ex",
               "test/sample_files/js/js_sample.js"
             ]
    end

    test "should return a list of all files except the skipped directories" do
      files = get_all_sample_files(%Config{skip_patterns: [~r/test\/sample_files\/js/]})

      assert files == [
               "test/sample_files/c_sample.c",
               "test/sample_files/ex_sample.ex"
             ]
    end
  end

  describe "read_file_list_contents/1" do
    test "should read the contents of all the files provided" do
      file_paths = get_all_sample_files()

      files_contents =
        file_paths
        |> FileUtils.read_file_list_contents()

      Enum.each(files_contents, fn {file_path, contents} ->
        assert file_path in file_paths
        assert String.length(contents) > 0
      end)
    end

    test "should return an empty list if file list is empty" do
      files =
        %Config{}
        |> FileUtils.get_all_files("./**/*.no_file")
        |> FileUtils.read_file_list_contents()

      assert files == []
    end
  end

  describe "get_file_list_codetags/2" do
    test "should return all the configured codetags found within some files" do
      config = %Config{skip_patterns: [~r/c_sample\.c/, ~r/js_sample\.js/]}
      files = get_all_sample_files(config)

      [{"test/sample_files/ex_sample.ex", codetag_results}] =
        files
        |> FileUtils.read_file_list_contents()
        |> FileUtils.get_file_list_codetags(config)

      assert length(codetag_results) == 2
    end

    test "should return an empty list if no codetags are found within some files" do
      config = %Config{
        skip_patterns: [~r/c_sample\.c/, ~r/js_sample\.js/],
        supported_codetags: []
      }

      files = get_all_sample_files(config)

      results =
        files
        |> FileUtils.read_file_list_contents()
        |> FileUtils.get_file_list_codetags(config)

      assert results == []
    end

    test "should return a list of files that only fullfil the configured codetags" do
      config = %Config{
        skip_patterns: [~r/c_sample\.c/, ~r/js_sample\.js/],
        supported_codetags: ["FIXME"]
      }

      files = get_all_sample_files(config)

      [{"test/sample_files/ex_sample.ex", codetag_results}] =
        files
        |> FileUtils.read_file_list_contents()
        |> FileUtils.get_file_list_codetags(config)

      assert length(codetag_results) == 1
    end
  end

  defp get_all_sample_files(config \\ %Config{}) do
    config
    |> FileUtils.get_all_files("./test/sample_files/**")
    |> Enum.sort()
  end
end
