defmodule ReactTest.TeamsEditions do
  use Ecto.Schema

  @required_fields ~w(team edition)a
  @primary_key false
  schema "teams_editions" do
    belongs_to :team, ReactTest.Teams
    belongs_to :edition, ReactTest.Editions
  end

  def changeset(event, params \\ %{}) do
    event
    |> Ecto.Changeset.cast(@required_fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end