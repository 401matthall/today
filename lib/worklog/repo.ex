defmodule Worklog.Repo do
  use Ecto.Repo,
    otp_app: :worklog,
    adapter: Ecto.Adapters.Postgres
end
