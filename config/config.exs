# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :journal, Journal.Guardian,
  issuer: "journal",
  secret_key: "so5Iq0d0Bs0vsaUarWwh7g4m3sTDz/a3Ntk61oBhTYlimUQaOUe7kZA6Wh5lsdj1"

config :journal, :api_auth,
  signup_token: "k4qhpO0a9jTWukZIcgw3SwoBmXW62X+y3X1jit8GkAknmdb9u2r8IoYOF5FS36sB"

config :journal,
  ecto_repos: [Journal.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :journal, JournalWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: JournalWeb.ErrorHTML, json: JournalWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Journal.PubSub,
  live_view: [signing_salt: "egBtHR9E"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :journal, Journal.Mailer, adapter: Swoosh.Adapters.Local

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  journal: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
