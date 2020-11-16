defmodule LiveViewTestWeb.EditionComponent do
  use LiveViewTestWeb, :live_component

  def render(assigns) do
    ~L"""
      <ul>
        <li>
          <%=@edition.date %>
          <ul>
            <%= for team <- @edition.teams do %>
            <li>
              <%= team.team_name %>
            </li>
            <% end %>
          </ul>
           <%= if(@edition.is_open) do %>
            <%= f = form_for :registration, "#", phx_submit: "save", phx_target: @myself %>
              <%= text_input f, :team_name, placeholder: "Teamnaam" %>
              <%= submit "Aanmelden" %>
            </form>
          <% end %>

      </li>
    </ul>
    """
  end

  def handle_event("save", %{"registration" => %{"team_name" => team_name}}, socket) do
    send self(), {:registrate_team, socket.assigns.edition.id, team_name}
    {:noreply, socket}
  end
end