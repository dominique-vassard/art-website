# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# General application configuration
config :artworks,
  fallback_locale: "fr",
  valid_locales: ~w(en fr)

# Configures the endpoint
config :artworks, ArtworksWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DOOb7J9ZbjZ3ZdNxNKB/Phd+KaTgBc38DFEBRb0UQMF1yBbV/napdbbU3rQ5ZoaP",
  render_errors: [view: ArtworksWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Artworks.PubSub,
  live_view: [signing_salt: "m5ZvQA+i"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
