defmodule BlogsAPI.Repo.Migrations.CreatePostsTable do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table :posts do
      add :title, :string
      add :content, :string
      add :userId, references(:users, type: :binary_id)

      timestamps([{:published, :updated}])
    end
  end
end
