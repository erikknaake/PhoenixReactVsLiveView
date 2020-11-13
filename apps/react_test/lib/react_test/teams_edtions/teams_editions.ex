defmodule ReactTest.TeamsEditions do
  use Ecto.Schema

  @required_fields ~w(teams editions)a
  @primary_key false
  @derive {Poison.Encoder, only: @required_fields}
  schema "teams_editions" do
    belongs_to :teams, ReactTest.Teams
    belongs_to :editions, ReactTest.Editions
  end

  def changeset(event, params \\ %{}) do
    event
    |> Ecto.Changeset.cast(@required_fields)
    |> Ecto.Changeset.validate_required(@required_fields)
    |> Ecto.Changeset.assoc_constraint(:teams)
    |> Ecto.Changeset.assoc_constraint(:editions)
  end
end