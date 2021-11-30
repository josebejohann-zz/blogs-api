defmodule BlogsAPI.Users.Get do
  @moduledoc false

  alias BlogsAPI.{Error, Repo, User}

  def call(id) do
    case Repo.get(User, id) do
      nil -> {:error, Error.user_not_found()}
      user -> {:ok, user}
    end
  end
end
