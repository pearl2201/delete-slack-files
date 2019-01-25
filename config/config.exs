# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :slack_tool,
  ecto_repos: [SlackTool.Repo]

# Configures the endpoint
config :slack_tool, SlackToolWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "1RDeVzKpL+J3NRqZIFAp5k/aaV7Xrlvvr1GRa7XHeub3C7BFnmDLRUrC40wcpMkg",
  render_errors: [view: SlackToolWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SlackTool.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
