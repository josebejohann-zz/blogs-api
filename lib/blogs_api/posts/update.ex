defmodule BlogsAPI.Posts.Update do
  alias BlogsAPI.{Error, Post, Repo}

  def call(%{"id" => id} = params) do
    case Repo.get(Post, id) do
      nil -> {:error, Error.post_not_found()}
      post -> do_update(post, params)
    end
  end

  defp do_update(post, params) do
    post
    |> Repo.preload([:user])
    |> Post.changeset(params)
    |> Repo.update()
    |> handle_update()
  end

  defp handle_update({:ok, result}), do: {:ok, Repo.preload(result, [:user])}
  defp handle_update({:error, reason}), do: {:error, Error.build(:bad_request, reason)}
end
