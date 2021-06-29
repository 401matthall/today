# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :worklog,
  ecto_repos: [Worklog.Repo]

# Configures the endpoint
config :worklog, WorklogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "y/FVsO0qZDcevB6YHw2i50Uo0s5L0USGJSRufLsbePkIA9yM/CcJcBYMry0eGjJc",
  render_errors: [view: WorklogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Worklog.PubSub,
  live_view: [signing_salt: "g3tYnZDx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :worklog, :pow,
  user: Worklog.Users.User,
  repo: Worklog.Repo,
  extensions: [PowResetPassword, PowEmailConfirmation],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  web_module: WorklogWeb,
  mailer_backend: WorklogWeb.Pow.Mailer,
  web_module_mailer: WorklogWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"