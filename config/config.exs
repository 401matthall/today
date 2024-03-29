# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :today,
  ecto_repos: [Today.Repo]

# Configures the endpoint
config :today, TodayWeb.Endpoint,
  url: [host: System.get_env("HOST_URL")|| "localhost"],
  http: [port: System.get_env("HTTP_PORT") || 4000],
  secret_key_base: "y/FVsO0qZDcevB6YHw2i50Uo0s5L0USGJSRufLsbePkIA9yM/CcJcBYMry0eGjJc",
  render_errors: [view: TodayWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Today.PubSub,
  live_view: [signing_salt: "g3tYnZDx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :today, :pow,
  user: Today.Users.User,
  repo: Today.Repo,
  extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_module: TodayWeb,
  mailer_backend: TodayWeb.Pow.Mailer,
  web_module_mailer: TodayWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
