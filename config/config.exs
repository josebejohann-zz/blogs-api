# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :blogs_api,
  namespace: BlogsAPI,
  ecto_repos: [BlogsAPI.Repo],
  generators: [binary_id: true]

config :blogs_api, BlogsAPI.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

# Configures the endpoint
config :blogs_api, BlogsAPIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Hal4o24rsOXCU+Yqs6okLpBIttRjsNLf7JHA3TvylsmFAVJfT3ycQitpnWJB7zTs",
  render_errors: [view: BlogsAPIWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: BlogsAPI.PubSub,
  live_view: [signing_salt: "LLfTnv/A"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
