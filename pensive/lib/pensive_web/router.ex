defmodule PensiveWeb.Router do
  # make routing functions available in this module
  use PensiveWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PensiveWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # 1st arg: all routes in this scope have paths starting with "/"
  # 2nd arg: scope all controller in namespace `PensieveWeb`
  #        - `PageController` == `PensieveWeb.PageController`
  scope "/", PensiveWeb do
    # pipe_through: apply the `pipeline :browser` to all routes
    pipe_through :browser

    # Default route when no path is given
    get "/", PageController, :home
    get "/about", PageController, :about
  end

  # Other scopes may use custom stacks.
  # scope "/api", PensiveWeb do
  #   pipe_through :api
  # end

  # Additional routes only for development and only if the `:dev_routes` env is set.
  # access at localhost:4000/dev/dashboard
  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:pensive, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PensiveWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
