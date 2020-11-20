defmodule LiveViewTestWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :liveViewTest_web,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {LiveViewTestWeb.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_live_view, git: "https://github.com/phoenixframework/phoenix_live_view"},
      {:floki, ">= 0.0.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
#      {:phoenix_live_dashboard, "~> 0.3.6"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:liveViewTest, in_umbrella: true},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:corsica, "~> 1.1"},
      # File uploads
      {:ex_aws_s3, git: "https://github.com/ex-aws/ex_aws_s3"},
#      {:ex_aws, git: "https://github.com/ex-aws/ex_aws"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"},
      {:httpoison, "~> 1.7"},
      {:timex, "~> 3.6"}
      # end file uploads
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "cmd npm install --prefix assets"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
