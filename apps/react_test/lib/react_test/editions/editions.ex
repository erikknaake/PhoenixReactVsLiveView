defmodule ReactTest.Editions do
  use Ecto.Schema

  @required_fields ~w(date)a
  schema "editions" do
    field :date, Ecto.Date
    many_to_many :teams, ReactTest.Teams, join_through: ReactTest.TeamsEditions
  end

  def changeset(event, params \\ %{}) do
    event
    |> Ecto.Changeset.cast(@required_fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end