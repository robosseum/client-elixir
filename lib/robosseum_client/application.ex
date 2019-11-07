defmodule RobosseumClient.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Starts a worker by calling: RobosseumClient.Worker.start_link(arg)
      # {RobosseumClient.Worker, arg},
      %{
        id: RobosseumClient.Player,
        start: {RobosseumClient.Player, :start_link, []}
      }
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RobosseumClient.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
