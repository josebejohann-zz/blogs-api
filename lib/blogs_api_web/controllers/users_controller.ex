defmodule BlogsAPIWeb.UsersController do
  use BlogsAPIWeb, :controller

  alias BlogsAPI.User
  alias BlogsAPIWeb.{Auth.Guardian, FallbackController}

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- BlogsAPI.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token)
    end
  end

  def sign_in(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("create.json", token: token)
    end
  end

  def index(conn, _) do
    with {:ok, users} <- BlogsAPI.list_users() do
      conn
      |> put_status(:ok)
      |> render("index.json", users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- BlogsAPI.show_user(id) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end
end
