defmodule UnPiped.MixProject do
  use Mix.Project

  def project do
    [
      app: :unpiped,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: [] ++ check_deps(),
      escript: escript()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :eex]
    ]
  end

  defp check_deps do
    [
      {:ex_check, "~> 0.14.0", only: [:dev], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false}
    ]
  end

  def escript do
    [
      main_module: UnPiped,
      emu_args: "-sname unpiped"
    ]
  end
end
