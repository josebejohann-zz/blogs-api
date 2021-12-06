defmodule BlogsAPI.Users.Get do
  alias BlogsAPI.{Error, Repo, User}

  def call() do
    case Repo.all(User) do
      nil -> {:ok, []}
      users -> {:ok, users}
    end
  end

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.user_not_found()}
      user -> {:ok, user}
    end
  end

  def by_email(email) do
    case Repo.get_by(User, email: email) do
      nil -> {:error, Error.user_not_found()}
      user -> {:ok, user}
    end
  end
end
