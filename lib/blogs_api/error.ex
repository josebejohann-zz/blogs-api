defmodule BlogsAPI.Error do
  @moduledoc false

  @keys [:status, :result]

  @enforce_keys @keys

  defstruct @keys

  def build(status, result) do
    %__MODULE__{
      status: status,
      result: result
    }
  end

  def user_not_found(), do: build(:not_found, "User not found.")
  def post_not_found(), do: build(:not_found, "Post not found.")
end
