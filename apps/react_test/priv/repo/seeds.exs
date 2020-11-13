# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ReactTest.Repo.insert!(%ReactTest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
team1 = ReactTest.Repo.insert!(%ReactTest.Teams{team_name: "KDG"})
team2 = ReactTest.Repo.insert!(%ReactTest.Teams{team_name: "Zona"})
team3 = ReactTest.Repo.insert!(%ReactTest.Teams{team_name: "Sint Joris"})
team4 = ReactTest.Repo.insert!(%ReactTest.Teams{team_name: "Witte Wieven"})
team5 = ReactTest.Repo.insert!(%ReactTest.Teams{team_name: "Graaf Otto groep"})

edition1 = ReactTest.Repo.insert!(%ReactTest.Editions{date: Ecto.Date.cast!({2020, 12, 6})})
edition2 = ReactTest.Repo.insert!(%ReactTest.Editions{date: Ecto.Date.cast!({2021, 3, 6})})

ReactTest.Repo.insert!(%ReactTest.TeamsEditions{teams: team1, editions: edition1})
ReactTest.Repo.insert!(%ReactTest.TeamsEditions{teams: team1, editions: edition2})

ReactTest.Repo.insert!(%ReactTest.TeamsEditions{teams: team2, editions: edition1})
ReactTest.Repo.insert!(%ReactTest.TeamsEditions{teams: team2, editions: edition2})

ReactTest.Repo.insert!(%ReactTest.TeamsEditions{teams: team3, editions: edition1})

ReactTest.Repo.insert!(%ReactTest.TeamsEditions{teams: team4, editions: edition2})