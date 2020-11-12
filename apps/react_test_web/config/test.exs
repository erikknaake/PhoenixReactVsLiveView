use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :react_test_web, ReactTestWeb.Endpoint,
  http: [port: 4001],
  server: false
