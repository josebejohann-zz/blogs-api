defmodule BlogsAPIWeb.PostsView do
  use BlogsAPIWeb, :view

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      title: post.title,
      content: post.content,
      userId: post.user_id
    }
  end

  def render("show.json", %{post: post}), do: post

  def render("index.json", %{posts: posts}), do: posts
end
