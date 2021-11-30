defmodule BlogsAPIWeb.UsersController do
  use BlogsAPIWeb, :controller

  alias BlogsAPI.User
  alias BlogsAPIWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- BlogsAPI.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
