defmodule VoteWeb.Router do
  use VoteWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {VoteWeb.LayoutView, :root}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :guardian do
    plug VoteWeb.Authentication.Pipeline
  end

  pipeline :browser_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", VoteWeb do
    pipe_through [:browser, :guardian]

    get "/", HomepageController, :index
    get "/pick-user/:ballot", PublicUserController, :index
    post "/pick-user/:ballot", PublicUserController, :assign

    post   "/login",           AuthController, :login
    post   "/register",        AuthController, :register
    get    "/register/verify", AuthController, :verify_email
    delete "/logout",          AuthController, :logout

    live "/b/:ballot", BallotLive, :index
    live "/b/:ballot/results", ResultsLive, :index
  end

  scope "/auth", VoteWeb do
    pipe_through [:browser, :guardian]

    get "/:provider",          AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", VoteWeb do
    pipe_through [:browser, :guardian, :browser_auth]

    live "/app", PageLive, :index
    live "/new", NewPollLive, :index
    live "/edit/:ballot", NewPollLive, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", VoteWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  # if Mix.env() in [:dev, :test] do
  #   import Phoenix.LiveDashboard.Router

  #   scope "/" do
  #     pipe_through :browser
  #     live_dashboard "/dashboard", metrics: VoteWeb.Telemetry
  #   end
  # end
end
