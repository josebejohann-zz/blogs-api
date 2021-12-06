defmodule BlogsAPI.Repo.Migrations.CreatePostsTable do
  @ false

  use Ecto.Migration

  def change do
    create table :posts do
      add :title, :string
      add :content, :string
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(inserted_at: :published, updated_at: :updated)
    end
  end
end
