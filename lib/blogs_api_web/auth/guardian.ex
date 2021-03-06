defmodule BlogsAPIWeb.Auth.Guardian do
  use Guardian, otp_app: :blogs_api

  alias BlogsAPI.{Error, User}
  alias BlogsAPI.Users.Get, as: GetUser

  def subject_for_token(%User{id: id}, _claims), do: {:ok, id}

  def resource_from_claims(claims) do
    claims
    |> Map.get("sub")
    |> GetUser.by_id()
  end

  def authenticate(%{"email" => email, "password" => password}) do
    with {:ok, %User{password_hash: hash} = user} <- GetUser.by_email(email),
         true <- Bcrypt.verify_pass(password, hash),
         {:ok, token, _claims} <- encode_and_sign(user) do
      {:ok, token}
    else
      false -> {:error, Error.build(:bad_request, "Invalid fields.")}
      error -> error
    end
  end

  def authenticate(_), do: {:error, Error.build(:bad_request, "Empty fields are not allowed.")}
end
