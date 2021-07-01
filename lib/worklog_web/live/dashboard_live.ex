defmodule TodayWeb.DashboardLive do
  use TodayWeb, :live_view
  require Logger
  require Ecto.Query

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
    end

    worklogs = Today.Worklog
      |> Ecto.Query.where(user_id: ^session["current_user"])
      |> Today.Repo.all
      |> Today.Repo.preload(:tags)

    {
      :ok,
      socket
        |> assign(current_user: session["current_user"])
        |> assign(session: session)
        |> assign(worklogs: worklogs)
    }
  end

end
