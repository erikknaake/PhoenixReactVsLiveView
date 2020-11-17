defmodule LiveViewTest.TeamsContext do
  import Ecto.Query
  alias LiveViewTest.{Repo, Teams}

#  def get_all do
#    from team in Teams
#    |> Repo.all()
#  end

  def create_if_not_exists(team_name) do
    existingTeam = Repo.one(from t in Teams, where: t.team_name == ^team_name)
    case existingTeam do
      nil -> Repo.insert!(%Teams{team_name: team_name})
      value -> value
    end
  end

end
