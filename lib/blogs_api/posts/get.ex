defmodule BlogsAPI.Posts.Get do
  @moduledoc false
  import Ecto.Query, only: [from: 2]

  alias BlogsAPI.{Error, Post, Repo}

  def call() do
    case Repo.all(from(p in Post, preload: [:user])) do
      nil -> {:ok, []}
      posts -> {:ok, posts}
    end
  end

  def by_id(id) do
    case Repo.get(from(p in Post, preload: [:user]), id) do
      nil -> {:error, Error.post_not_found()}
      post -> {:ok, post}
    end
  end
end
