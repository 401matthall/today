defmodule WorklogWeb.Router do
  use WorklogWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router,
  extensions: [PowResetPassword, PowEmailConfirmation]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {WorklogWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug WorklogWeb.AssignUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :admin do
  end

  scope "/" do
    pipe_through :browser
    pow_routes()
    pow_extension_routes()
  end

  scope "/", WorklogWeb do
    pipe_through :browser
    live "/", PageLive, :index
  end

  scope "/worklogs", WorklogWeb do
    pipe_through [:browser, :authenticated]
    live "/", WorklogsLive, :index
    live "/new", WorklogsLive, :new
    live "/search", WorklogsLive, :search
  end

  scope "/tags", WorklogWeb do
    pipe_through [:browser, :authenticated]
    live "/", TagsLive, :index
    live "/new", TagsLive, :new
    live "/search", TagsLive, :search
  end

  scope "/users", WorklogWeb do
    pipe_through [:browser, :authenticated, :admin]
    live "/", UsersLive, :index
    live "/new", UsersLive, :new
    live "/edit", UsersLive, :edit
    live "/search", UsersLive, :search
  end

  # Other scopes may use custom stacks.
  # scope "/api", WorklogWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: WorklogWeb.Telemetry
    end
  end
end
