defmodule TodayWeb.AssignUser do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _params) do
    put_session(conn, :current_user, if (conn.assigns.current_user) do conn.assigns.current_user.id else nil end)
  end
end
