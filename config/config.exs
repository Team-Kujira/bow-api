# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :bow_api,
  ecto_repos: [BowApi.Repo]

# Configures the endpoint
config :bow_api, BowApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BowApiWeb.ErrorView, accepts: ~w(json html), layout: false],
  pubsub_server: BowApi.PubSub,
  live_view: [signing_salt: "qoLhVOOB"],
  protocol_options: [idle_timeout: 60_000]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
  origin: [~r/https:\/\/([a-z]+\.)?kujira\.network$/, "http://localhost:1234"]

config :esbuild,
  version: "0.17.11",
  bow_api: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.4",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :memoize,
  cache_strategy: Kujira.CacheStrategy

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
