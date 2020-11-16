defmodule LiveViewTest.TeamsEditionsContext do
  import Ecto.Query
  alias LiveViewTest.{Repo, TeamsEditions, Teams, Editions}

  @doc """
    Inserts a team into an edition, when the team does not exist the team is created
    Returns the updated edition
  """
  def put(date, team) do
    {ok, result} = Repo.transaction(
      fn ->
        existingEdition = Repo.one(from e in Editions, where: e.date == ^date)
        editionResult = case existingEdition do
          nil -> Repo.insert!(%Editions{date: date})
          value -> value
        end
        teamResult = Repo.insert!(%Teams{team_name: team})

        Repo.insert!(%TeamsEditions{teams: teamResult, editions: editionResult})
        editionResult
      end
    )
    result
    |> Repo.preload(:teams)
  end


end