defmodule ReactTest.TeamsEditionsQueries do
  import Ecto.Query
  alias ReactTest.{Repo, TeamsEditions, Teams, Editions}

  def put(date, team) do
    date |> IO.inspect()
    team |> IO.inspect()
    Repo.transaction(
      fn ->
        teamResult = Repo.insert!(%Teams{team_name: team})
        editionResult = Repo.insert!(%Editions{date: date})
        Repo.insert!(%TeamsEditions{teams: teamResult, editions: editionResult})
      end
    )
  end
end