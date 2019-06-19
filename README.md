# ExTodo

[![Hex.pm](https://img.shields.io/hexpm/v/ex_todo.svg)](http://hex.pm/packages/ex_todo) [![Build Status](https://travis-ci.org/akoutmos/ex_todo.svg?branch=master)](https://travis-ci.org/akoutmos/ex_todo)

A simple utility to keep track of codetags in your project. The list of codetags that are captured is configurable via a `.todo.exs` file, and you can even have `mix todo` return a non-zero exit status if it finds certain codetags in your codebase. For example if you would like ex_todo to fail in CI/CD if FIXME or BUG codetags are found, you can do that.

ExTodo works on all file formats and can be given a list of regular expressions for files/paths that should be skipped.

Inspiration for output taken from https://www.npmjs.com/package/leasot

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_todo` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_todo, "~> 0.1.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/ex_todo](https://hexdocs.pm/ex_todo).

## Usage

ExTodo comes with 2 mix tasks. One to run the documentation coverage report, and another to generate a `.todo.exs` config file.

To run the ex_todo mix task and generate a report run: `mix todo`
To generate a `.todo.exs` config file with defaults, run: `mix todo.gen.config`

## Sample report

By running `mix todo` in this repo we get:

<img src="https://raw.githubusercontent.com/akoutmos/ex_todo/master/sample_output.jpg" alt="ExTodo">
