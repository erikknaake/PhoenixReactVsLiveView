defmodule LiveViewTest.TeamsEditions do
  use Ecto.Schema

  @required_fields ~w(teams editions)a
  @all_fields @required_fields ++ ~w(photo_file_name)a
  @primary_key false
  @derive {Jason.Encoder, only: @required_fields}
  schema "teams_editions" do
    belongs_to :teams, LiveViewTest.Teams
    belongs_to :editions, LiveViewTest.Editions
    field :photo_file_name, :string
  end

  def changeset(event, params \\ %{}) do
    event
    |> Ecto.Changeset.cast(params, @required_fields)
    |> Ecto.Changeset.validate_required(@required_fields)
    |> Ecto.Changeset.assoc_constraint(:teams)
    |> Ecto.Changeset.assoc_constraint(:editions)
  end
end