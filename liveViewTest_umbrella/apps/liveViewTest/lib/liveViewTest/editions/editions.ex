defmodule LiveViewTest.Editions do
  use Ecto.Schema

  @required_fields ~w(date)a
  @derive {Jason.Encoder, only: @required_fields}
  schema "editions" do
    field :date, :date
    field :is_open, :boolean
    many_to_many :teams, LiveViewTest.Teams, join_through: LiveViewTest.TeamsEditions
  end

  def changeset(event, params \\ %{}) do
    event
    |> Ecto.Changeset.cast(@required_fields)
    |> Ecto.Changeset.validate_required(@required_fields)
  end
end