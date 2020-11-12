use Mix.Config

# Configure your database
config :react_test, ReactTest.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "react_test_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
