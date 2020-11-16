defmodule LiveViewTest.EditionsContext do
  import Ecto.Query
  alias LiveViewTest.{Repo, Editions, TeamsEditions, Teams}

  def create_edition(attrs \\ %{}) do
    %Editions{}
    |> Editions.changeset(attrs)
    |> Repo.insert()
  end

  def change_edition(edition, attrs \\ %{}) do
    Editions.changeset(edition, attrs)
  end

  def get_all do
    Repo.all(from edition in Editions,
         preload: [:teams])
  end
end
