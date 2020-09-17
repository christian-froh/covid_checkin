import Config

config :covid_checkin,
  url: "https://#{System.fetch_env!("HOST")}"

config :covid_checkin, CovidCheckin.Repo,
  # ssl: true,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.fetch_env!("POOL_SIZE"))

config :covid_checkin, CovidCheckinWeb.Endpoint,
  http: [
    port: String.to_integer(System.fetch_env!("PORT")),
    transport_options: [socket_opts: [:inet6]]
  ],
  url: [host: System.fetch_env!("HOST")],
  check_origin: ["https://#{System.fetch_env!("HOST")}", "http://#{System.fetch_env!("HOST")}"],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :covid_checkin, CovidCheckinWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
