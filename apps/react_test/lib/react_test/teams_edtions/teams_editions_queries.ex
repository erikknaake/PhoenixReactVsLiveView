defmodule ReactTest.TeamsEditionsQueries do
  import Ecto.Query
  alias ReactTest.{Repo, TeamsEditions, Teams, Editions}

  def put(date, team) do
    date
    |> IO.inspect()
    team
    |> IO.inspect()
    Repo.transaction(
      fn ->
        existingEdition = Repo.one(from e in Editions, where: e.date == ^date)
        editionResult = case existingEdition do
          nil ->  Repo.insert!(%Editions{date: date})
          value -> value
        end
        teamResult = Repo.insert!(%Teams{team_name: team})

        Repo.insert!(%TeamsEditions{teams: teamResult, editions: editionResult})
      end
    )
  end
end