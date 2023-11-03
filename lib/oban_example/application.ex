defmodule ObanExample.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Fly.RPC,
      ObanExampleWeb.Telemetry,
      ObanExample.Repo.Local,
      {DNSCluster, query: Application.get_env(:oban_example, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ObanExample.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ObanExample.Finch},
      {Oban, Application.fetch_env!(:oban_example, Oban)},
      ObanExample.JobMachine,
      # Start a worker by calling: ObanExample.Worker.start_link(arg)
      # {ObanExample.Worker, arg},
      # Start to serve requests, typically the last entry
      ObanExampleWeb.Endpoint
    ]

    :ok = Oban.Telemetry.attach_default_logger(level: :debug)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ObanExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ObanExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
