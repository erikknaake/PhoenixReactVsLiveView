defmodule LiveViewTestWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    IO.puts("Starting phoenix, MIX_ENV: #{System.get_env("MIX_ENV")}")
    children = [
      # Start the Telemetry supervisor
      LiveViewTestWeb.Telemetry,
      # Start the Endpoint (http/https)
      LiveViewTestWeb.Endpoint
      # Start a worker by calling: LiveViewTestWeb.Worker.start_link(arg)
      # {LiveViewTestWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveViewTestWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LiveViewTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
