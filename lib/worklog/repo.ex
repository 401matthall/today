defmodule Today.Repo do
  use Ecto.Repo,
    otp_app: :today,
    adapter: Ecto.Adapters.Postgres

    def init(_type, config) do
      database_url = System.get_env("DATABASE_URL")

      if database_url == nil do
        {:ok, config}
      else
        {:ok, Keyword.put(config, :url, database_url)}
      end
    end
end
