defmodule LiveViewTestWeb.EditionsLive do
  use LiveViewTestWeb, :live_view
  alias ExAws.S3
  @impl true
  def mount(_params, _session, socket) do
    IO.puts("Mount")
    if connected?(socket) do
      LiveViewTest.TeamsEditionsContext.subscribe()
    end
    {
      :ok,
      socket
      |> assign(editions: LiveViewTest.EditionsContext.get_all())
      |> assign(:uploaded_files, [])
      |> allow_upload(:avatar, accept: :any, max_entries: 3, external: &presign_upload/2)
    }
  end

  @impl true
  def handle_info({:registrate_team, date, team_name}, socket) do
    #    IO.inspect(team_photo)
    #    {:ok, file_name} = LiveViewTestWeb.TeamPhotoUploader.store(team_photo)
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


  defp presign_upload(entry, socket) do
    IO.puts("presign")
    IO.inspect(entry)

    key = entry.client_name
    config = %{
      region: "us-east-1",
      access_key_id: "minio",
      secret_key: "minio123",
      object: key,
      bucket: "uploads",
      expire_seconds: 24 * 60 * 60 * 10,
      host: "localhost",
      port: 9000,
      protocol: "http"
    }

    %{postURL: post_url, formData: form_data} = LiveViewTestWeb.MinioSigning.pre_signed_post_policy(config)

    meta = %{uploader: "S3", key: key, url: post_url, fields: form_data} |> IO.inspect()
    {:ok, meta, socket}

  end
  def handle_event("validate", _params, socket) do
    IO.puts("validate")
    {:noreply, socket}
  end

  @impl true
  def handle_event("save", _params, socket) do
#    IO.puts("save")
#    uploaded_files =
#      consume_uploaded_entries(
#        socket,
#        :avatar,
#        fn %{path: path}, _entry ->
#          dest = Path.join("priv/static/uploads", Path.basename(path))
#          File.cp!(path, dest)
#          Routes.static_path(socket, "/uploads/#{Path.basename(dest)}")
#        end
#      )
#    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
    {:noreply, socket}
  end
end
