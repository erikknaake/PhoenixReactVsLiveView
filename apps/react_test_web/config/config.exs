# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :react_test_web,
  namespace: ReactTestWeb,
  ecto_repos: [ReactTest.Repo]

# Configures the endpoint
config :react_test_web, ReactTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "lWZiAf0m/0ILvJqM4fQlvjlPywuWKT6ymxKs9xt3w/FahSuOgRowCgJKN+IfsUzg",
  render_errors: [view: ReactTestWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ReactTestWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :react_test_web, :generators,
  context_app: :react_test

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
