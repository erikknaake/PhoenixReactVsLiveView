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
    {lookup_result, _} = System.cmd("nslookup", ["phoenix"])
    IO.inspect(lookup_result)
    Regex.scan(~r/[0-9,a-f]{12}/, lookup_result) |> IO.inspect()
    |> List.flatten
    |> Enum.reject(
         fn x ->
          IO.puts("looking at for rejection")
          IO.puts("x: #{to_string(x)}")
#          own_hostname = System.get_env("CONTAINER_IP")
          {own_hostname, 0} = System.cmd("hostname", [])
          IO.puts("Own ip: #{to_string(own_hostname) |>String.trim("\n")}")
          IO.puts("Comparison result: #{to_string(x) == String.trim(to_string(own_hostname), "\n")}")
           to_string(x) == String.trim(to_string(own_hostname), "\n")
         end
       )
    |> IO.inspect()
    |> Enum.map(
         fn ip ->
           IO.puts("Connecting to #{ip}")
           Node.connect(:"standard#{ip}")
         end
       )
  end
end
