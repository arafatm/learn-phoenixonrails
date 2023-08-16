defmodule Pensive.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PensiveWeb.Telemetry,
      # Start the Ecto repository
      Pensive.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Pensive.PubSub},
      # Start Finch
      {Finch, name: Pensive.Finch},
      # Start the Endpoint (http/https)
      PensiveWeb.Endpoint
      # Start a worker by calling: Pensive.Worker.start_link(arg)
      # {Pensive.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pensive.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PensiveWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
