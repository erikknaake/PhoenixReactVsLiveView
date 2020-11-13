defmodule ReactTest.EditionsQueries do
  import Ecto.Query
  alias ReactTest.{Repo, Editions, TeamsEditions, Teams}

  def get_all do
    Repo.all(
      from edition in Editions,
          preload: [:teams])
  end
end
