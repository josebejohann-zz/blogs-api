defmodule BlogsAPI.User do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias BlogsAPI.Post
  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:displayName, :email, :password]

  @derive {Jason.Encoder, only: [:id, :displayName, :email, :image]}

  schema "users" do
    field :displayName, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :image, :string

    has_many :posts, Post

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required([:email])
    |> validate_required([:password])
    |> validate_length(:displayName, min: 8)
    |> validate_length(:password, min: 6)
    |> validate_format(:email, ~r/(\w+)@([\w.]+)/)
    |> unique_constraint([:email])
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
