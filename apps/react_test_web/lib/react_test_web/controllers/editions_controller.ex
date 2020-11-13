defmodule EditionsController do
  @moduledoc false
  use ReactTestWeb, :controller

  def get_all(conn, _) do
    editions = ReactTest.EditionsQueries.get_all()
    |> Enum.map(fn(edition) ->
      team_names = Enum.map(edition.teams, fn(team) ->
        team.team_name
      end)
         %{"date" => edition.date, "teams" => team_names}
    end)
    conn
    |> json(editions)
  end

  def put(conn, %{"year" => year}) do
    %{"_json" => body} = conn.params
    ReactTest.EditionsGenServer.put(%{year: year, teams: body})
    json conn, %{}
  end
end
