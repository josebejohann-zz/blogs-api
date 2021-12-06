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

    post "/user", UsersController, :create
    post "/login", UsersController, :sign_in
  end

  scope "/", BlogsAPIWeb do
    pipe_through :auth

    resources "/user", UsersController, except: [:new, :edit, :create]

    get "/post/search/", PostsController, :search
    resources "/post", PostsController, except: [:new, :edit]
  end
end
