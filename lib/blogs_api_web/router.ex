defmodule BlogsAPIWeb.Router do
  use BlogsAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogsAPIWeb do
    pipe_through :api

    resources "/users", UsersController, except: [:new, :edit]
  end
end
