defmodule RobosseumClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :robosseum_client,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RobosseumClient.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_gen_socket_client, "~> 2.1.0"},
      {:websocket_client, "~> 1.2"},
      {:poison, "~> 2.0"}
      # {:phoenixchannelclient, "~> 0.1.0"}
    ]
  end
end
