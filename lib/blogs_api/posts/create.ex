defmodule BlogsAPI.Posts.Create do
  alias BlogsAPI.{Error, Post, Repo}

  def call(params) do
    params
    |> Post.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %Post{}} = result), do: result

  defp handle_insert({:error, result}) do
    {:error, Error.build(:bad_request, result)}
  end
end
