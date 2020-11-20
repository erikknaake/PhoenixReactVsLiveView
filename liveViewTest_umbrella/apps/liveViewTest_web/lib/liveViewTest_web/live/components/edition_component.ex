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
      <%= for entry <- @uploads.avatar.entries do %>
    <%= entry.client_name %> - <%= entry.progress %>%
    <% end %>
            <%= f = form_for :registration, "#", phx_submit: "save", phx_target: @myself %>
              <%= text_input f, :team_name, placeholder: "Teamnaam" %>
              <%= submit "Aanmelden" %>
            </form>
          <% end %>

      </li>
    </ul>
    """
  end

  def handle_event("validate", _params, socket) do
    IO.puts("validate")
    {:noreply, socket}
  end

  def handle_event(
        "save",
        %{
          "registration" =>
          %{
            "team_name" => team_name
          }
        },
        socket
      ) do
#    uploaded_files =
#      consume_uploaded_entries(socket, :team_photo, fn %{path: path}, _entry ->
#        dest = Path.join("priv/static/uploads", Path.basename(path))
#        File.cp!(path, dest)
#        Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
#      end) |> IO.inspect()

    send self(), {:registrate_team, socket.assigns.edition.date, team_name}
    {:noreply, socket}
  end
end