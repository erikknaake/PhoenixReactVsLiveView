defmodule LiveViewTest.TeamsEditionsContext do
  import Ecto.Query
  alias LiveViewTest.{Repo, TeamsEditions, TeamsContext, EditionsContext}

  @doc """
    Inserts a team into an edition, when the team does not exist the team is created
    Returns the updated edition
  """
  def put(date, team) do
    {:ok, result} = Repo.transaction(
      fn ->
        editionResult = EditionsContext.create_if_not_exists(date)
        teamResult = TeamsContext.create_if_not_exists(team)

        teamEdition = %TeamsEditions{teams: teamResult, editions: editionResult}
          |> Repo.insert!()

        editionResult
      end
    )
    result
    |> Repo.preload(:teams)
    |> broadcast(:team_registrated_for_edition)
  end

  defp broadcast(data, event) do
    Phoenix.PubSub.broadcast(LiveViewTest.PubSub, "teams_editions", {event, data})
    data
  end

  def subscribe do
    Phoenix.PubSub.subscribe(LiveViewTest.PubSub, "teams_editions")
  end


end