defmodule LiveViewTest.EditionsContext do
  import Ecto.Query
  alias LiveViewTest.{Repo, Editions}

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

  def create_if_not_exists(date) do
    existingEdition = Repo.one(from e in Editions, where: e.date == ^date)
    case existingEdition do
      nil -> Repo.insert!(%Editions{date: date})
      value -> value
    end
  end
end
