defmodule GeoTracker.Repo do
  use Ecto.Repo,
    otp_app: :geo_tracker,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20
end
