defmodule BlogsAPI do
  @moduledoc false

  alias BlogsAPI.Users.Create, as: CreateUser
  alias BlogsAPI.Users.Delete, as: DeleteUser
  alias BlogsAPI.Users.Get, as: ShowUser
  alias BlogsAPI.Users.List, as: ListUsers

  defdelegate create_user(params), to: CreateUser, as: :call
  defdelegate list_users(), to: ListUsers, as: :call
  defdelegate show_user(id), to: ShowUser, as: :call
  defdelegate delete_user(id), to: DeleteUser, as: :call
end
