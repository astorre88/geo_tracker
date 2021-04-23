# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :geo_tracker,
  ecto_repos: [GeoTracker.Repo]

# Configures the endpoint
config :geo_tracker, GeoTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "M4Uu6GrUHginBIOgFi5Ax4Nay9d+mRYhugQrey1nVc+RkPuKU0w9vcW6+cjEb2nV",
  render_errors: [view: GeoTrackerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GeoTracker.PubSub,
  live_view: [signing_salt: "thci67DU"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
