defmodule Medix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MedixWeb.Telemetry,
      Medix.Repo,
      {DNSCluster, query: Application.get_env(:medix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Medix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Medix.Finch},
      # Start a worker by calling: Medix.Worker.start_link(arg)
      # {Medix.Worker, arg},
      # Start to serve requests, typically the last entry
      MedixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Medix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MedixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
