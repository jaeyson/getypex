# Typex

[//]: # "Badges"
[![Dependabot][dependabot badge]][dependabot]
[![Actions Status][actions badge]][actions]
[![Super Linter][linter badge]][linter]

[//]: # "Links"
[dependabot]: https://github.com/jaeyson/typex
[actions]: https://github.com/jaeyson/typex/actions/workflows/ci.yml
[linter]: https://github.com/jaeyson/typex/actions/workflows/linter.yml

[//]: # "Image sources"
[dependabot badge]: https://badgen.net/dependabot/jaeyson/typex/111643794?icon=dependabot
[actions badge]: https://github.com/jaeyson/typex/workflows/ci.yml/badge.svg
[linter badge]: https://github.com/jaeyson/typex/actions/workflows/linter.yml/badge.svg


Library for checking types. Similar from `PHP`'s `gettype` or `JavaScript`'s `typeof`. Created this package to better understand how [`Protocol`](https://elixir-lang.org/getting-started/protocols.html) works.

**Note**: try `IEx.Info.info("hello world")`, [Elixir's implementation](https://github.com/elixir-lang/elixir/blob/master/lib/iex/lib/iex/info.ex) via shell or visit Elixir's [Protocol guide](https://elixir-lang.org/getting-started/protocols.html) instead of this package, since it's based from that module.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `typex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:typex, "~> 0.1.0"}
  ]
end
```

Docs can be found at [https://hexdocs.pm/typex](https://hexdocs.pm/typex).

## Usage

```elixir
iex(1)> Typex.check("hello Typex")
"String (UTF-8)"

iex(2)> Typex.check({:ok, "message"})
"Tuple"
```
