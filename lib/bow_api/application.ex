defmodule BowApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      BowApi.Repo,
      # Start the Telemetry supervisor
      BowApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: BowApi.PubSub},
      # Start the Endpoint (http/https)
      BowApiWeb.Endpoint,
      # Start a worker by calling: BowApi.Worker.start_link(arg)
      # {BowApi.Worker, arg}
      BowApi.Node,
      {Kujira.Invalidator, pubsub: BowApi.PubSub}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BowApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BowApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
