defmodule BlogsAPI do
  @moduledoc false

  alias BlogsAPI.Users.Create, as: UserCreate

  defdelegate create_user(params), to: UserCreate, as: :call
end
