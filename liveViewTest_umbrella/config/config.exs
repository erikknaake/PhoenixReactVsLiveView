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
IO.puts("Config: #{Mix.env()}")
# Configure Mix tasks and generators
config :liveViewTest,
  ecto_repos: [LiveViewTest.Repo]

config :liveViewTest_web,
  ecto_repos: [LiveViewTest.Repo],
  generators: [context_app: :liveViewTest]

# Configures the endpoint
config :liveViewTest_web, LiveViewTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SOOqSnVHFV0ryPiPTFz4NUNVtsF/L09jkFBWmgULBR7M5PQTuKzA13kq4SsqyTNO",
  render_errors: [view: LiveViewTestWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: LiveViewTest.PubSub,
  live_view: [signing_salt: "SEn+vxkx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# If using S3:
config :ex_aws,
       json_codec: Jason,
       access_key_id: System.get_env("AWS_ACCESS_KEY_ID") || "minio",
       secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY") || "ucY>Au}Q'Ue]UUF7VY9[/Mz^iR9x6R2rqrRFEV^v>}d:["

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"