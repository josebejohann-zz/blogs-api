defmodule BlogsAPIWeb.Router do
  use BlogsAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BlogsAPIWeb.Auth.Pipeline
  end

  scope "/", BlogsAPIWeb do
    pipe_through :api

    resources "/users", UsersController, except: [:new, :edit, :index]
    post "/login", UsersController, :sign_in
  end

  scope "/", BlogsAPIWeb do
    pipe_through :auth

    get "/users", UsersController, :index
  end
end
