defmodule ChatterWeb.Router do
  use ChatterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ChatterWeb.Auth.Pipeline
  end

  pipeline :browser_auth do
    plug ChatterWeb.Auth.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatterWeb do
    pipe_through :browser
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:create]
    get "/", SessionController, :new
    delete "/", SessionController, :logout
  end

  scope "/", ChatterWeb do
    pipe_through [:browser, :browser_auth]

    resources "/users", UserController, except: [:new, :create]
    get "/chat", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatterWeb do
  #   pipe_through :api
  # end
end
