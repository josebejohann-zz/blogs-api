defmodule BlogsAPI.Users.List do
  @moduledoc false

  alias BlogsAPI.{Repo, User}

  def call() do
    case Repo.all(User) do
      nil -> {:ok, []}
      user -> {:ok, user}
    end
  end
end
