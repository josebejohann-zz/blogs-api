defmodule BlogsAPI.Users.Delete do
  alias BlogsAPI.{Error, Repo, User}

  def call(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.user_not_found()}
      user -> {:ok, Repo.delete(user)}
    end
  end
end
