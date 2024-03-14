defmodule GomokuBoardBackend.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      #  GomokuBoardBackendWeb.Telemetry,
      #  GomokuBoardBackend.Repo,
      #  {DNSCluster, query: Application.get_env(:gomoku_board_backend, :dns_cluster_query) || :ignore},
      {GomokuBoardBackend.EngineManager, []},
      {Phoenix.PubSub, name: GomokuBoardBackend.PubSub},
      # Start the Finch HTTP client for sending emails
      #  {Finch, name: GomokuBoardBackend.Finch},
      # Start a worker by calling: GomokuBoardBackend.Worker.start_link(arg)
      # {GomokuBoardBackend.Worker, arg},
      # Start to serve requests, typically the last entry
      GomokuBoardBackendWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GomokuBoardBackend.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GomokuBoardBackendWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
