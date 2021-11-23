defmodule TodayWeb.WorklogsLive do
  use TodayWeb, :live_view
  require Logger
  require Ecto.Query
  alias Today.Worklog

  @default_per_page "5"

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket) do
    end

    {
      :ok,
      socket
      |> assign(current_user: session["current_user"])
      |> assign(current_user_timezone: get_current_user_timezone(session["current_user"]))
      |> assign(session: session)
      |> assign(show_new_worklog_modal: false)
      |> assign(show_edit_worklog_modal: false)
      |> assign(pagination: %{page_number: "1", per_page: @default_per_page, total_items: "0"})
    }
  end

  @impl true
  def handle_params(params, _url, socket) do

    # action - index or search - adjust query
    # params - tag_text, tag_id, and page_number - also adjust
    # page_number - adjusts the query for both index and search
    is_valid = true
    is_valid = if validate_integer(params["per_page"]) == :invalid do false else is_valid end
    is_valid = if validate_integer(params["page_number"]) == :invalid do false else is_valid end
    case is_valid do
      false ->
        {
          :noreply,
          socket
          |> assign(worklogs: [])
          |> put_flash(:error, "parameters page_number and per_page must be a valid integer")
        }
      true ->
        {
          :noreply,
          socket
          |> handle_params(params)
          |> apply_action(socket.assigns.live_action, params)
          |> fetch_worklogs(params)
        }
    end
  end

  def fetch_worklogs(socket, params) do
    worklogs = Worklog.by_user_id(socket.assigns.current_user)
    |> apply_tags(params)
    |> apply_pagination(params, socket)
    |> populate_worklogs()

    assign(socket, worklogs: worklogs)
  end

  def validate_integer(value) do
    try do
      cond do
        value == nil ->
          :valid
        String.to_integer value ->
          :valid
      end
    rescue
      ArgumentError -> :invalid
    end
  end

  def apply_pagination(query, _params, socket) do
    pagination = socket.assigns.pagination
    Worklog.apply_pagination(query, String.to_integer(pagination.page_number), String.to_integer(pagination.per_page))
    |> Ecto.Query.limit(^String.to_integer(pagination.per_page))
  end

  def apply_tags(query, params) do
     case params do
      %{"tag_id" => tag_id} -> Worklog.by_tag_id(query, tag_id)
      %{"tag_text" => tag_text} -> Worklog.by_tag_text(query, tag_text)
      _ -> query
    end
  end

  def populate_worklogs(query) do
    Today.Repo.all(query) |> Today.Repo.preload(:tags)
  end

  defp handle_params(socket, params) do
    pagination = socket.assigns.pagination

    pagination = if params["per_page"] != nil do
      %{pagination | per_page: params["per_page"]}
    else
      %{pagination | per_page: @default_per_page}
    end

    pagination = if params["page_number"] != nil do
      %{pagination | page_number: params["page_number"]}
    else
      pagination
    end

    assign(socket, pagination: pagination)
  end

  defp apply_action(socket, :index, _params) do
    assign(socket, :page_title, "Today - Worklogs")
  end

  defp apply_action(socket, :search, _params) do
    assign(socket, :page_title, "Today - Tag Search")
  end

  def handle_event("previous_page", params, socket) do
    pagination = socket.assigns.pagination
    page_number = case String.to_integer(pagination.page_number) do
      n when n <= 1 -> 1
      n when n > 1 -> n - 1
    end
    # @TODO update url with params
    new_socket =
      assign(socket, pagination: %{pagination | page_number: Integer.to_string(page_number)})
      |> fetch_worklogs(params)
    {:noreply, new_socket}
  end

  def handle_event("next_page", params, socket) do
    pagination = socket.assigns.pagination
    page_number = case pagination.page_number do
      n when n <= 0 -> 1
      n when n >= 1 -> String.to_integer(n) + 1
    end
    # @TODO update url with params
    new_socket =
      assign(socket, pagination: %{pagination | page_number: Integer.to_string(page_number)})
      |> fetch_worklogs(params)
    {:noreply, new_socket}
  end

  @impl true
  def handle_event("search_tags", form, socket) do
    %{"search_term" => search_term} = form
    case search_term do
      "" -> {:noreply, push_patch(socket, to: Routes.worklogs_path(socket, :index))}
      _ -> {:noreply, push_patch(socket, to: Routes.worklogs_path(socket, :search, tag_text: search_term))}
    end
  end

  @impl true
  def handle_event("show_new_worklog_modal", _params, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, "Today - New Worklog")
      |> assign(show_new_worklog_modal: true)
    }
  end

  @impl true
  def handle_event("hide_new_worklog_modal", _params, socket) do
    {
      :noreply,
      socket
      |> assign(show_new_worklog_modal: false)
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

  @impl true
  def handle_event("show_edit_worklog_modal", params, socket) do
    worklog = Worklog.fetch_by_id_with_tags(params["worklog-id"])
    tag_string = worklog.tags
    |> Enum.map(fn(tag) -> tag.text end)
    |> Enum.join(", ")

    worklog = %{worklog | tag_string: tag_string}
    changeset = Worklog.create_update_changeset(worklog)

    {
      :noreply,
      socket
      |> assign(page_title: "Today - Edit Worklog")
      |> assign(worklog: worklog)
      |> assign(changeset: changeset)
      |> assign(show_edit_worklog_modal: true)
    }
  end

  @impl true
  def handle_event("hide_edit_worklog_modal", _params, socket) do
    {
      :noreply,
      socket
      |> assign(show_edit_worklog_modal: false)
    }
  end

  @impl true
  def handle_event("edit_worklog", params, socket) do
    case update_worklog(socket.assigns.changeset, params["worklog"]) do
      {:ok, _} -> {:noreply, socket |> put_flash(:info, "Worklog saved.") |> push_redirect(to: Routes.worklogs_path(socket, :index), replace: true)}
      {:error, %Ecto.Changeset{}} -> {:noreply, put_flash(socket, :error, "An error has occured trying to persist a worklog.")}
    end
  end

  defp persist_worklog(worklog_params = %{}) do
    worklog = %Today.Worklog{}
    changeset = Today.Worklog.changeset(worklog, %{title: worklog_params["title"], body: worklog_params["body"], user_id: worklog_params["user_id"], tag_string: worklog_params["tags"]})
    Today.Repo.insert(changeset)
  end

  defp update_worklog(changeset = %Ecto.Changeset{}, params = %{}) do
    worklog = Today.Repo.get(Worklog, changeset.data.id) |> Today.Repo.preload(:tags)
    new_changeset = Today.Worklog.changeset(worklog, %{title: params["title"], body: params["body"], tag_string: params["tags"], user_id: worklog.user_id})
    Today.Repo.update(new_changeset)
  end

  defp get_current_user_timezone(user_id) do
    user = Today.Repo.get(Today.Users.User, user_id)
    case user.timezone do
      nil -> "UTC"
      timezone -> timezone
    end
  end
end
