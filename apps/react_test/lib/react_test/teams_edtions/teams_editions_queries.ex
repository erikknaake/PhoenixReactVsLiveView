defmodule ReactTest.TeamsEditionsQueries do
  import Ecto.Query
  alias ReactTest.{Repo, TeamsEditions}

  def get_all do
    Repo.all(from team_edition in TeamsEditions,
             preload: :edition,
             preload: :team)
  end
end