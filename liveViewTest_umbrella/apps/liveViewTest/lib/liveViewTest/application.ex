defmodule LiveViewTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      LiveViewTest.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: LiveViewTest.PubSub}
      # Start a worker by calling: LiveViewTest.Worker.start_link(arg)
      # {LiveViewTest.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: LiveViewTest.Supervisor)
  end
end
