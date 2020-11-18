# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LiveViewTest.Repo.insert!(%LiveViewTest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
if ! LiveViewTest.Repo.exists?(LiveViewTest.Teams) do
  team1 = LiveViewTest.Repo.insert!(%LiveViewTest.Teams{team_name: "KDG"})
  team2 = LiveViewTest.Repo.insert!(%LiveViewTest.Teams{team_name: "Zona"})
  team3 = LiveViewTest.Repo.insert!(%LiveViewTest.Teams{team_name: "Sint Joris"})
  team4 = LiveViewTest.Repo.insert!(%LiveViewTest.Teams{team_name: "Witte Wieven"})
  team5 = LiveViewTest.Repo.insert!(%LiveViewTest.Teams{team_name: "Graaf Otto groep"})

  {:ok, date1} = Date.new(2020, 12, 6)
  {:ok, date2} = Date.new(2021, 03, 6)
  edition1 = LiveViewTest.Repo.insert!(%LiveViewTest.Editions{date: date1, is_open: false})
  edition2 = LiveViewTest.Repo.insert!(%LiveViewTest.Editions{date: date2, is_open: true})

  LiveViewTest.Repo.insert!(%LiveViewTest.TeamsEditions{teams: team1, editions: edition1})
  LiveViewTest.Repo.insert!(%LiveViewTest.TeamsEditions{teams: team1, editions: edition2})

  LiveViewTest.Repo.insert!(%LiveViewTest.TeamsEditions{teams: team2, editions: edition1})
  LiveViewTest.Repo.insert!(%LiveViewTest.TeamsEditions{teams: team2, editions: edition2})

  LiveViewTest.Repo.insert!(%LiveViewTest.TeamsEditions{teams: team3, editions: edition1})

  LiveViewTest.Repo.insert!(%LiveViewTest.TeamsEditions{teams: team4, editions: edition2})

  LiveViewTest.Repo.insert!(%LiveViewTest.TeamsEditions{teams: team5, editions: edition2})
end
