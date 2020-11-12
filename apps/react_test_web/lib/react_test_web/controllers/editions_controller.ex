defmodule EditionsController do
  @moduledoc false
  use ReactTestWeb, :controller

  def get_all(conn, _) do
    editions = ReactTest.EditionsGenServer.get_all()
    |> IO.inspect()
    conn
    |> json(editions)
  end

  def put(conn, %{"year" => year}) do
    %{"_json" => body} = conn.params
    ReactTest.EditionsGenServer.put(%{year: year, teams: body})
    json conn, %{}
  end
end
