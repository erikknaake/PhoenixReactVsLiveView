defmodule ReactTest.Repo.Migrations.AddTeamsEditions do
  use Ecto.Migration

  def change do

    create table(:teams) do
      add :team_name, :string, size: 50
    end

    create table(:editions) do
      add :date, :date
    end

    create table(:teams_editions, primary_key: false) do
      add :edition_id, references(:editions)
      add :team_id, references(:teams)
    end

  end
end
