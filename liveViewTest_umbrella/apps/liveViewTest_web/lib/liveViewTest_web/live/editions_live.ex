defmodule LiveViewTestWeb.EditionsLive do
  use LiveViewTestWeb, :live_view
  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, editions: LiveViewTest.EditionsContext.get_all())}
  end

  def handle_info({:registrate_team, edition_id, team_name}, socket) do
    # update the list of cards in the socket
    updated_editions = Enum.map(
      socket.assigns.editions,
      fn(edition) ->
        if(edition.id == edition_id) do
          inserted = LiveViewTest.TeamsEditionsContext.put(edition.date, team_name)
          inserted
#          Map.merge(edition, %{"teams" => [inserted | edition.teams]}) #%{edition | "teams" => [team_name | teams]}
        else
          edition
        end
      end
    )
    {:noreply, assign(socket, editions: updated_editions)}
  end

#  @impl true
#  def handle_event("save", %{"team_name" => team_name, "date" => date}, socket) do
#
##    case LiveViewTest.EditionsContext.add_team(team_name, date) do
##      {:ok, edition} ->
##        socket = update(socket, :editions, fn editions -> [edition | editions] end)
##      {:noreply, socket} ->
##    end
##
##    {:noreply, assign(socket, ok: :ok)}
#  end

end
