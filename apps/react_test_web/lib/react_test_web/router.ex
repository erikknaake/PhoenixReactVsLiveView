defmodule ReactTestWeb.Router do
  use ReactTestWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Plug.Parsers, parsers: [:json],
                       json_decoder: Poison
  end

  scope "/", ReactTestWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
   scope "/api" do
     pipe_through :api

     get "/editions", EditionsController, :get_all
     post "/editions/:year", EditionsController, :put
   end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard"
    end
  end
end
