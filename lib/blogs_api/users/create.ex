defmodule BlogsAPI.Users.Create do
  @moduledoc false

  alias BlogsAPI.{Error, Repo, User}
  alias Ecto.Changeset

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %User{}} = result), do: result

  defp handle_insert({:error, %Changeset{errors: [email: {error, [constraint: :unique]}]}}) do
    {:error, Error.build(:conflict, error)}
  end

  defp handle_insert({:error, result}) do
    {:error, Error.build(:bad_request, result)}
  end
end
