defmodule BullionWeb.Router do
  use BullionWeb, :router

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

  scope "/", BullionWeb do
    pipe_through :browser

    get "/", PageController, :index

    get "/game/new", GameController, :new
    get "/game/view", GameController, :lookup
  end

  # Other scopes may use custom stacks.
  # scope "/api", BullionWeb do
  #   pipe_through :api
  # end
end
