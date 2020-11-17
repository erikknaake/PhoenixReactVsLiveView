defmodule LiveViewTest.TeamsEditionsContext do
  import Ecto.Query
  alias LiveViewTest.{Repo, TeamsEditions, TeamsContext, EditionsContext}
  @team_edition_topic = "teams_editions"

  @doc """
    Inserts a team into an edition, when the team does not exist the team is created
    Returns the updated edition and broadcasts the update
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
    LiveViewTest.PubSubHelper.broadcast(@team_edition_topic, event, data)
  end

  def subscribe do
    LiveViewTest.PubSubHelper.subscribe(@team_edition_topic)
  end


end