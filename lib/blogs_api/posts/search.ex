defmodule BlogsAPI.Posts.Search do
  import Ecto.Query, only: [from: 2]

  alias BlogsAPI.{Post, Repo}

  def call(params) do
    search_term = get_in(params, ["q"])

    posts =
      Post
      |> handle_search(search_term)
      |> Repo.all()
      |> Repo.preload([:user])

    {:ok, posts}
  end

  defp handle_search(query, search_term) do
    wildcard_search = "%#{search_term}%"

    from post in query,
      where: ilike(post.title, ^wildcard_search),
      or_where: ilike(post.content, ^wildcard_search)
  end
end
