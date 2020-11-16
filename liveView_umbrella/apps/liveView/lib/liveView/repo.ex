defmodule LiveView.Repo do
  use Ecto.Repo,
    otp_app: :liveView,
    adapter: Ecto.Adapters.Postgres
end
