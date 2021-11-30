defmodule BlogsAPI.Post do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias BlogsAPI.User

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:title, :content]

  schema "posts" do
    field :title, :string
    field :content, :string

    belongs_to :user, User

    timestamps([{:published, :updated}])
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
