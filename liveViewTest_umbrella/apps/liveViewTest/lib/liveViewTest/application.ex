defmodule LiveViewTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    connect_to_cluster()
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

  def connect_to_cluster do
    # Docker internal DNS lookup
    IO.puts("Node name: #{node()}")
    {lookup_result, _} = System.cmd("nslookup", ["phoenix"])

    Regex.scan(~r/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/, lookup_result)
    |> List.flatten
    |> Enum.reject(
         fn x ->
          {own_hostname, 0} = System.cmd("hostname", ["-i"])
           x == own_hostname
         end
       )
    |> Enum.map(
         fn ip ->
           Node.connect(:"phoenix@#{ip}")
         end
       )
       IO.puts("Connected to: ")
       IO.inspect(Node.list())
  end
end
