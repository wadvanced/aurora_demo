defmodule AuroraDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AuroraDemoWeb.Telemetry,
      AuroraDemo.Repo,
      {DNSCluster, query: Application.get_env(:aurora_demo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AuroraDemo.PubSub},
      # Start a worker by calling: AuroraDemo.Worker.start_link(arg)
      # {AuroraDemo.Worker, arg},
      # Start to serve requests, typically the last entry
      AuroraDemoWeb.Endpoint
    ]

    {:ok, _} = Application.ensure_all_started(:aurora_uix)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuroraDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AuroraDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
