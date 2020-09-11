defmodule CovidCheckin.Repo do
  use Ecto.Repo,
    otp_app: :covid_checkin,
    adapter: Ecto.Adapters.Postgres
end
