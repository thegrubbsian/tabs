defmodule Tabs.Mixfile do
  use Mix.Project

  def project do
    [app: :tabs,
     version: "0.0.1",
     elixir: "~> 0.15.1",
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:exredis, github: "artemeff/exredis", ref: "0ba9bb528db65cec8d479d05e4fbf3a81eaaf730"},
      {:timex, "0.12.4"}
    ]
  end
end
