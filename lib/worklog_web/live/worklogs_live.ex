defmodule TodayWeb.WorklogsLive do
  use TodayWeb, :live_view
  require Logger

  alias Today.Worklog

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
    end

    worklogs = Worklog.fetch_with_assoc_by_user_id(session["current_user"])
    {
      :ok,
      socket
      |> assign(current_user: session["current_user"])
      |> assign(current_user_timezone: get_current_user_timezone(session["current_user"]))
      |> assign(session: session)
      |> assign(worklogs: worklogs)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Today - Worklogs")
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Today - New Worklog")
  end

  defp apply_action(socket, :tag_by_id, params) do
    worklogs = Worklog.fetch_by_user_id_and_tag_id(socket.assigns.current_user, params["id"])

    socket
    |> assign(:page_title, "Today - Tag Search")
    |> assign(worklogs: worklogs)
  end

  defp apply_action(socket, :tag_by_text, params) do
    worklogs = Worklog.fetch_by_user_id_and_tag_text(socket.assigns.current_user, params["text"])

    socket
    |> assign(:page_title, "Today - Tag Search")
    |> assign(worklogs: worklogs)
  end

  @impl true
  def handle_event("search_tags", form, socket) do
    %{"search_term" => search_term} = form
    {:noreply, push_patch(socket, to: Routes.worklogs_path(socket, :tag_by_text, search_term))}
  end

  @impl true
  def handle_event("goto_worklog_view", _params, socket) do
    {:noreply,
      socket
      |> push_patch(to: Routes.worklogs_path(socket, :new))
    }
  end

  @impl true
    def handle_event("create_worklog", params, socket) do
    worklog = params["worklog"]
    |> Map.put("user_id", socket.assigns.current_user)
    case persist_worklog(worklog) do
      {:ok, _} -> {:noreply, socket |> put_flash(:info, "Worklog saved.") |> push_redirect(to: Routes.worklogs_path(socket, :index), replace: true)}
      {:error, %Ecto.Changeset{}} -> {:noreply, put_flash(socket, :error, "An error has occured while trying to save worklog.")}
    end
  end

  defp persist_worklog(worklog_params = %{}) do
    worklog = %Today.Worklog{}
    changeset = Today.Worklog.changeset(worklog, %{title: worklog_params["title"], body: worklog_params["body"], user_id: worklog_params["user_id"], tag_string: worklog_params["tags"]})
    Today.Repo.insert(changeset)
  end

  defp get_current_user_timezone(user_id) do
    user = Today.Repo.get(Today.Users.User, user_id)
    case user.timezone do
      nil -> "UTC"
      timezone -> timezone
    end
  end
end
