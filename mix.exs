defmodule Typex.MixProject do
  use Mix.Project

  @source_url "https://github.com/jaeyson/typex"
  @version "0.1.0"

  def project do
    [
      app: :getypex,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :test,
      aliases: aliases(),
      deps: deps(),
      description:
        "Library for checking types. Similar from PHP's gettype or JavaScript's typeof.",
      docs: docs(),
      package: package(),
      name: "Getypex",
      source_url: @source_url
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.5.6", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.25.3", only: :dev, runtime: false},
      {:tzdata, "~> 1.1.0"}
    ]
  end

  defp aliases do
    [
      test: [
        "format --check-formatted",
        "credo --strict",
        "test --trace"
      ]
    ]
  end

  defp docs do
    [
      api_reference: false,
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      canonical: "http://hexdocs.pm/getypex",
      extras: [
        "README.md",
        "CHANGELOG.md",
        "LICENSE"
      ]
    ]
  end

  defp package do
    [
      maintainers: ["Jaeyson Anthony Y."],
      licenses: ["MIT"],
      links: %{
        "Github" => @source_url
      }
    ]
  end
end
