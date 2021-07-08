defmodule TodayWeb.DashboardLive do
  use TodayWeb, :live_view
  require Logger
  require Ecto.Query
  alias Today.Worklog

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
    end

    # worklogs = Worklog.fetch_with_assoc_by_user_id(session["current_user"])
    {
      :ok,
      socket
        |> assign(current_user: session["current_user"])
        |> assign(session: session)
        # |> assign(worklogs: worklogs)
    }
  end

end
