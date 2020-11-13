defmodule ReactTest.Teams do
  use Ecto.Schema

  @required_fields ~w(team_name)a
  @derive {Poison.Encoder, only: @required_fields}
  schema "teams" do
    field :team_name, :string
    many_to_many :editions, ReactTest.Editions, join_through: ReactTest.TeamsEditions
  end

  def changeset(event, params \\ %{}) do
    event
    |> Ecto.Changeset.cast(@required_fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end