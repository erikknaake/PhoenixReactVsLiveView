defmodule LiveView.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LiveView.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveView.PubSub}
      # Start a worker by calling: LiveView.Worker.start_link(arg)
      # {LiveView.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: LiveView.Supervisor)
  end
end
