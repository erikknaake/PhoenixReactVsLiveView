defmodule EditionsController do
  @moduledoc false
  use ReactTestWeb, :controller

  def get_all(conn, _) do
    editions = ReactTest.EditionsQueries.get_all() #|> IO.inspect() #ReactTest.EditionsGenServer.get_all()
    mapped = Enum.map(editions, fn(edition) ->
      team_names = Enum.map(edition.teams, fn(team) ->
        team.team_name |> IO.inspect()
      end) |> IO.inspect()
         %{"date" => edition.date, "teams" => team_names} |> IO.inspect()
    end) |> IO.inspect()
    conn
    |> json(mapped)
  end

  def put(conn, %{"year" => year}) do
    %{"_json" => body} = conn.params
    ReactTest.EditionsGenServer.put(%{year: year, teams: body})
    json conn, %{}
  end
end
