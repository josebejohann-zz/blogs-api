defmodule BlogsAPI.Users.Index do
  @moduledoc false

  alias BlogsAPI.{Repo, User}

  def call() do
    case Repo.all(User) do
      nil -> {:ok, []}
      users -> {:ok, users}
    end
  end
end
