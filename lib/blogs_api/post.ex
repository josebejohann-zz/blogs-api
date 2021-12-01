defmodule BlogsAPI.Post do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias BlogsAPI.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:title, :content, :user_id]
  @update_params [:title, :content]

  @derive {Jason.Encoder, only: [:id, :published, :updated] ++ @required_params}

  schema "posts" do
    field :title, :string
    field :content, :string

    belongs_to :user, User

    timestamps(inserted_at: :published, updated_at: :updated)
  end

  def changeset(params) do
    %__MODULE__{}
    |> changes(params, @required_params)
  end

  def changeset(struct, params) do
    struct
    |> changes(params, @update_params)
  end

  def changes(struct, params, fields) do
    struct
    |> cast(params, fields)
    |> validate_required(fields)
    |> foreign_key_constraint(:user_id)
  end
end
