# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :liveView,
  ecto_repos: [LiveView.Repo]

config :liveView_web,
  ecto_repos: [LiveView.Repo],
  generators: [context_app: :liveView]

# Configures the endpoint
config :liveView_web, LiveViewWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jeBrIpNZChoq9n8RB2QK4Rz6KwvvvvaySoeX4PQUG8EyjBYQIWApyRk8w1haJjBz",
  render_errors: [view: LiveViewWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveView.PubSub,
  live_view: [signing_salt: "cofGZ091"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
