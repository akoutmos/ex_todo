%ExTodo.Config{
  error_codetags: ["FIXME", "BUG"],
  skip_patterns: [
    ~r/\.git/,
    ~r/_build/,
    ~r/deps/,
    ~r/cover/,
    ~r/docs/,
    ~r/\.todo\.exs/,
    ~r/README\.md/,
    ~r/^lib\/.*/,
    ~r/file_utils_test\.exs$/
  ],
  supported_codetags: ["NOTE", "TODO", "FIXME", "HACK", "BUG"]
}
