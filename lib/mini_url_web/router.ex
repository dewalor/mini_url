defmodule MiniUrlWeb.Router do
  use MiniUrlWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MiniUrlWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MiniUrlWeb do
    pipe_through :browser

    live "/", UrlLive.Index, :new
    live "/urls", UrlLive.Index, :index
    live "/stats", UrlLive.Index, :show_stats
    post "/download", DownloadController, :create
    get "/:short", UrlController, :translate
    live "/urls/new", UrlLive.Index, :new
    live "/urls/:id/edit", UrlLive.Index, :edit
    live "/urls/:id", UrlLive.Show, :show
    live "/urls/:id/show/edit", UrlLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", MiniUrlWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:mini_url, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MiniUrlWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
