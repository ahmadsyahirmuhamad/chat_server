defmodule ChatServerWeb.Router do
  use ChatServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_authenticated do
    plug ChatServer.AuthAccessPipeline
  end

  scope "/", ChatServerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", ChatServerWeb.Api do
    pipe_through [:api]
    post "/sessions", SessionController, :create
  end

  scope "/api", ChatServerWeb.Api do
    pipe_through [:api, :api_authenticated]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ChatServerWeb do
  #   pipe_through :api
  # end
end
