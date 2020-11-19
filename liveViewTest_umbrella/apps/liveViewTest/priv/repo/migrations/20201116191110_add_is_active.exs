defmodule LiveViewTest.Repo.Migrations.AddIsActive do
  use Ecto.Migration

  def change do
    alter table("editions") do
      add :is_open, :boolean
    end
  end
end
