defmodule EditionsController do
  @moduledoc false
  use ReactTestWeb, :controller

  def get_all(conn, _) do
    conn
    |> json([%{year: 2019, teams: ["KDG", "Zona"]}, %{year: 2020, teams: ["KDG", "Zona", "Sint Joris"]}])
  end

  def put_all(conn, params) do
    {:ok, data, _conn_details} = Plug.Conn.read_body(conn)
    IO.inspect(data)
    conn
    |> json([%{year: 2018, teams: ["KDG"]}, %{year: 2019, teams: ["KDG", "Zona"]}, %{year: 2020, teams: ["KDG", "Zona", "Sint Joris"]}])
  end
end
