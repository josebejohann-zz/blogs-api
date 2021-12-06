defmodule BlogsAPI.Posts.Delete do
  alias BlogsAPI.{Error, Repo, Post}

  def call(id) do
    case Repo.get(Post, id) do
      nil -> {:error, Error.post_not_found()}
      post -> Repo.delete(post)
    end
  end
end
