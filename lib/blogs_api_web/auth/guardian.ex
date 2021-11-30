defmodule BlogsAPIWeb.Auth.Guardian do
  @moduledoc false

  use Guardian, otp_app: :blogs_api

  alias BlogsAPI.User
  alias BlogsAPI.Users.Get, as: UserGet

  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> UserGet.call()
  end
end
