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
    IO.inspect(:name)
    IO.inspect(node())
    IO.inspect(Node.list())
    {lookup_result, _} = System.cmd("nslookup", ["phoenix"])
    IO.inspect(lookup_result)
#    Regex.scan(~r/[0-9,a-f]{12}/, lookup_result) |> IO.inspect()
    Regex.scan(~r/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/, lookup_result) |> IO.inspect()
    |> List.flatten
    |> Enum.reject(
         fn x ->
          IO.puts("looking at for rejection")
          IO.puts("x: #{to_string(x)}")
#          own_hostname = System.get_env("CONTAINER_IP") |> IO.inspect()
          {own_hostname, 0} = System.cmd("hostname", ["-i"])
          IO.puts("Own ip: #{to_string(own_hostname) |>String.trim("\n")}")
          IO.puts("Comparison result: #{to_string(x) == String.trim(to_string(own_hostname), "\n")}")
           to_string(x) == String.trim(to_string(own_hostname), "\n")
         end
       )
    |> IO.inspect()
#    |> Enum.map(fn ip ->
#      IO.puts("nslookup for ip: #{ip}")
#      {container_id_lookup, _} = System.cmd("nslookup", [ip])
#      IO.puts("nslookup result #{container_id_lookup}")
#      Regex.scan(~r/[0-9,a-f]{12}/, container_id_lookup) |> IO.inspect()
#    end)
#    |> List.flatten |> IO.inspect()
    |> Enum.map(
         fn ip ->
           IO.puts("Connecting to phoenix@#{ip}")
           Node.connect(:"phoenix@#{ip}")
           Node.list()
         end
       )
  end
end
