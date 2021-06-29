defmodule TodayWeb.WorklogsLive do
  use TodayWeb, :live_view
  require Logger

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
    end

    {
      :ok,
      socket
        |> assign(current_user: session["current_user"])
        |> assign(session: session)
    }
  end

  @impl true
    def handle_event("create_worklog", params, socket) do
    worklog = params["worklog"]
    |> Map.put("user_id", socket.assigns.current_user)
    case persist_worklog(worklog) do
      {:ok, _} -> {:noreply, put_flash(socket, :info, "Saved!")}
      {:error, %Ecto.Changeset{}} -> {:noreply, put_flash(socket, :error, "An error has occured while trying to save worklog.")}
    end
  end

  defp persist_worklog(worklog_params = %{}) do
    worklog = %Today.Worklog{}
    changeset = Today.Worklog.changeset(worklog, %{title: worklog_params["title"], body: worklog_params["body"], user_id: worklog_params["user_id"]})
    Today.Repo.insert(changeset)
    # @TODO manage tags
    # tags = worklog_params["tags"]
    # split string on commas into separate elements
    # lower case all elements (should probably be done at the persistence layer)
    # check if each tag exists, if not create it
    # include tags in persist
  end

end
