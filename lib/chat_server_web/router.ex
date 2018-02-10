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

  pipeline :graphql do
    plug ChatServerWeb.Context
  end

  scope "/", ChatServerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # depreciated
  # scope "/api", ChatServerWeb.Api do
  #   pipe_through [:api, :api_authenticated]

  #   post "/sessions", SessionController, :create
  # end

  scope "/api" do
    pipe_through [:api, :api_authenticated, :graphql]

    forward "/graphql", Absinthe.Plug,
      schema: ChatServerWeb.Schema


  end

  forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: ChatServerWeb.Schema

end
