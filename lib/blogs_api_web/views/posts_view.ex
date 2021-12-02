defmodule BlogsAPIWeb.PostsView do
  use BlogsAPIWeb, :view

  def render("post.json", %{post: post}), do: post

  def render("index.json", %{posts: posts}), do: posts
end
