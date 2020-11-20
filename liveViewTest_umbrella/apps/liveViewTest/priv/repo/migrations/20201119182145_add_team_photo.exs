defmodule LiveViewTest.Repo.Migrations.AddTeamPhoto do
  use Ecto.Migration

  def change do
    alter table("teams_editions") do
      add :photo_file_name, :string
    end
  end
end
