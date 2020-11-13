defmodule ReactTestWeb.EditionsChannel do
  use Phoenix.Channel

  @impl true
  def join("edition" <> date, _message, socket) do
    IO.puts("someone joined edition:#{date}")
    {:ok, socket}
  end

  def team_joined(all_editions) do
    payload = %{
      "editions" => all_editions
    }
    ReactTestWeb.Endpoint.broadcast!("edition", "team_joined", payload)
  end
end
