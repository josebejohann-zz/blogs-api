defmodule BlogsAPI.Users.Show do
  @moduledoc false

  alias BlogsAPI.{Error, Repo, User}

  def call(id) do
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
