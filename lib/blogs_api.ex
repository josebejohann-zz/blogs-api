defmodule BlogsAPI do
  @moduledoc false

  alias BlogsAPI.Users.Create, as: CreateUser
  alias BlogsAPI.Users.List, as: ListUsers

  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate list_users(), to: ListUsers, as: :call
end
