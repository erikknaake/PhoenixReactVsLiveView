defmodule EditionsController do
  @moduledoc false
  use ReactTestWeb, :controller

  def get_all_mapped() do
    ReactTest.EditionsQueries.get_all()
    |> Enum.map(
         fn (edition) ->
           team_names = Enum.map(
             edition.teams,
             fn (team) ->
               team.team_name
             end
           )
           %{"date" => edition.date, "teams" => team_names}
         end
       )
  end

  def get_all(conn, _) do
    editions = get_all_mapped()
    conn
    |> json(editions)
  end

  def put(conn, %{"date" => date}) do
    %{"_json" => team} = conn.params
    casted = Ecto.Date.cast!(date)
    ReactTest.TeamsEditionsQueries.put(casted, team)
    ReactTestWeb.EditionsChannel.team_joined(get_all_mapped())
    json conn, %{}
  end
end
