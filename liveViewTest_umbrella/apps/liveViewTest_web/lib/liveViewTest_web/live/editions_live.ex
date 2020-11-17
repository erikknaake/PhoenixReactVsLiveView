defmodule LiveViewTestWeb.EditionsLive do
  use LiveViewTestWeb, :live_view
  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: LiveViewTest.TeamsEditionsContext.subscribe()
    {:ok, assign(socket, editions: LiveViewTest.EditionsContext.get_all())}
  end

  @impl true
  def handle_info({:registrate_team, date, team_name}, socket) do
    LiveViewTest.TeamsEditionsContext.put(date, team_name)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:team_registrated_for_edition, inserted_edition}, socket) do
    updated_editions = Enum.map(
      socket.assigns.editions,
      fn (edition) ->
        if(edition.id == inserted_edition.id) do
          inserted_edition
        else
          edition
        end
      end
    )
    {:noreply, assign(socket, editions: updated_editions)}
  end


end
