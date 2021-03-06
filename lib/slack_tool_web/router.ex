defmodule SlackToolWeb.Router do
  use SlackToolWeb, :router

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

  scope "/", SlackToolWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/", SlackToolWeb do
    pipe_through :api

    post "/", SlackController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", SlackToolWeb do
  #   pipe_through :api
  # end
end
