defmodule Identicon.Mixfile do
  use Mix.Project

  def project do
    [
      app: :identicon,
      version: "0.1.0",
      elixir: ">= 1.3.1",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      escript: escript,
      name: "Identicon",
      docs: [main: "Identicon", 
             extras: ["README.md"]]
    ]
  end

  def escript do
    [
      main_module: Identicon.Main
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
        {:egd, github: "erlang/egd"},
        {:ex_doc, "~>0.14", only: :dev, runtime: false}
    ]
  end
end
