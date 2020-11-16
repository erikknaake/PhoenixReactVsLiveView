defmodule LiveViewTest.Teams do
  use Ecto.Schema

  @required_fields ~w(team_name)a
  @derive {Jason.Encoder, only: @required_fields}
  schema "teams" do
    field :team_name, :string
    many_to_many :editions, LiveViewTest.Editions, join_through: LiveViewTest.TeamsEditions
  end

  def changeset(event, params \\ %{}) do
    event
    |> Ecto.Changeset.cast(@required_fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end