defmodule BlogsAPIWeb.PostsController do
  use BlogsAPIWeb, :controller

  alias BlogsAPI.Post
  alias BlogsAPIWeb.Auth.Guardian.Plug, as: GuardianPlug
  alias BlogsAPIWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    user = GuardianPlug.current_resource(conn)
    params = Map.put(params, "user_id", user.id)

    with {:ok, %Post{} = post} <- BlogsAPI.create_post(params) do
      conn
      |> put_status(:created)
      |> render("post.json", post: post)
    end
  end

  def index(conn, _) do
    with {:ok, posts} <- BlogsAPI.get_all_posts() do
      conn
      |> put_status(:ok)
      |> render("index.json", posts: posts)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, post} <- BlogsAPI.get_post_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", post: post)
    end
  end

  def update(conn, params) do
    user = GuardianPlug.current_resource(conn)

    with {:ok, post} <- BlogsAPI.update_post(params) do
      case user.id == post.user_id do
        true ->
          conn
          |> put_status(:ok)
          |> render("post.json", post: post)

        false ->
          conn
          |> put_status(:unauthorized)
          |> json(%{message: "Unauthorized user."})
      end
    end
  end

  def search(conn, params) do
    with {:ok, posts} <- BlogsAPI.search_posts(params) do
      conn
      |> put_status(:ok)
      |> render("index.json", posts: posts)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = GuardianPlug.current_resource(conn)

    with {:ok, post} <- BlogsAPI.delete_post(id) do
      case user.id == post.user_id do
        true ->
          conn
          |> put_status(:no_content)
          |> text("")

        false ->
          conn
          |> put_status(:unauthorized)
          |> json(%{message: "Unauthorized user."})
      end
    end
  end
end
