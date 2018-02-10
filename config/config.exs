# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chat_server,
  ecto_repos: [ChatServer.Repo]

# Configures the endpoint
config :chat_server, ChatServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YzMu0LBu3csFUIzkV5b8WPQFlm/UZBLvggQ+QzsGFu5dxry2DRqXSvO/F6NF6ZbE",
  render_errors: [view: ChatServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ChatServer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :chat_server, ChatServer.AuthAccessPipeline,
  module: ChatServer.Guardian,
  error_handler: ChatServer.Auth.AuthErrorHandler

config :chat_server, ChatServer.Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "ChatServer",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "atqbpf0ll8rBhu7vll184M9/rk5/H9/DY6caDdsf70giMIbfxEbgeE8tmJ3w7Os8",
  serializer: ChatServer.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

