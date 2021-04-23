defmodule GeoTracker.Repo do
  use Ecto.Repo,
    otp_app: :geo_tracker,
    adapter: Ecto.Adapters.Postgres
end
