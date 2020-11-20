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

    config = %{
      region: "us-east-1",
      access_key_id: System.fetch_env("AWS_ACCESS_KEY_ID") || "minio",
      secret_access_key: System.fetch_env("AWS_SECRET_ACCESS_KEY") || "ucY>Au}Q'Ue]UUF7VY9[/Mz^iR9x6R2rqrRFEV^v>}d:["
    }

    #    {:ok, fields} =
    #      S3.sign_form_upload(config, bucket,
    #        key: key,
    #        content_type: entry.client_type,
    #        max_file_size: uploads.avatar.max_file_size,
    #        expires_in: :timer.hours(1)
    #      )
    #      S3.presigned_url(config, :post, bucket, key)
    key = entry.client_name
    response = HTTPoison.get!("http://localhost:3000/#{key}") |> IO.inspect()
    %{"formData" => fields, "postURL" => url} = Jason.decode!(response.body) |> IO.inspect()

    meta = %{uploader: "S3", key: key, url: url, fields: fields}
    {:ok, meta, socket}
#    {:ok, %{uploader: "S3", entrypoint: signed_url}, socket}
#    {:ok, %{uploader: "UpChunk", entrypoint: signed_url}, socket}
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
