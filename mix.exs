defmodule Auth0Plug.MixProject do
  use Mix.Project

  def project do
    [
      app: :auth0_plug,
      version: "1.0.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:plug_cowboy, "~> 2.5"},
      {:jason, "~> 1.2"},
      {:joken, "~> 2.4"},
      {:joken_jwks, "~> 1.5"}
    ]
  end
end
