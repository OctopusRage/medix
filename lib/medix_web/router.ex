defmodule MedixWeb.Router do
  use MedixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MedixWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MedixWeb do
    pipe_through :browser

    live "/posts", PostLive.Index, :index
    live "/posts/new", PostLive.Index, :new
    live "/posts/:id/edit", PostLive.Index, :edit

    live "/posts/:id", PostLive.Show, :show
    live "/posts/:id/show/edit", PostLive.Show, :edit


    live "/queue_groups", QueueGroupLive.Index, :index
    live "/queue_groups/new", QueueGroupLive.Index, :new
    live "/queue_groups/:id/edit", QueueGroupLive.Index, :edit

    live "/queue_groups/:id", QueueGroupLive.Show, :show
    live "/queue_groups/:id/show/edit", QueueGroupLive.Show, :edit

    live "/sessions/new/:group_id", SessionLive.Index, :new
    live "/sessions/list/:group_id", SessionLive.Index, :index
    live "/sessions/:group_id/edit/:id", SessionLive.Index, :edit

    live "/sessions/:group_id/show/:id", SessionLive.Show, :show



    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", MedixWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:medix, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MedixWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
