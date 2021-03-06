# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :covid_checkin,
  ecto_repos: [CovidCheckin.Repo],
  url: "http://localhost:4000"

# Configures the endpoint
config :covid_checkin, CovidCheckinWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rZoiZlldrrwMEeXiUACbiylaWlOgZNaAgrXexTqJhfHypvLvYQbIorEJKhuih5Kz",
  render_errors: [view: CovidCheckinWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CovidCheckin.PubSub,
  live_view: [signing_salt: "6EBKAOi+"],
  http: [
    protocol_options: [
      max_header_name_length: 10_000_000,
      max_header_value_length: 10_000_000,
      max_headers: 10_000_000,
      max_request_line_length: 10_000_000
    ]
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
