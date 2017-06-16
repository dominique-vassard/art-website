# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :artworks,
  ecto_repos: [Artworks.Repo],
  fallback_language: "fr",
  valid_languages: ~w(en fr)

# Configures the endpoint
config :artworks, Artworks.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "DOOb7J9ZbjZ3ZdNxNKB/Phd+KaTgBc38DFEBRb0UQMF1yBbV/napdbbU3rQ5ZoaP",
  render_errors: [view: Artworks.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Artworks.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
