defmodule BlogsAPIWeb.Router do
  use BlogsAPIWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BlogsAPIWeb do
    pipe_through :api
  end
end
