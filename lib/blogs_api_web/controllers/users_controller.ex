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
    with {:ok, users} <- BlogsAPI.get_all_users() do
      conn
      |> put_status(:ok)
      |> render("index.json", users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- BlogsAPI.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _user} <- BlogsAPI.delete_user(id) do
      conn
      |> put_status(:no_content)
      |> text('')
    end
  end
end
