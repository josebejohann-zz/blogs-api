defmodule BlogsAPI.Posts.GetTest do
  use BlogsAPI.DataCase, async: true

  import BlogsAPI.Factory

  alias BlogsAPI.{Error, Post}
  alias BlogsAPI.Posts.Get

  describe "call/0" do
    setup do
      user = insert(:user, Bcrypt.add_hash("123456"))
      post = insert(:post, %{user_id: user.id})

      {:ok, user: user, post: post}
    end

    test "returns all posts" do
      response = Get.call()

      assert {:ok, [%Post{}]} = response
    end

    test "returns an empty array if no post was created" do
      Repo.delete_all(Post)

      assert {:ok, []} = Get.call()
    end
  end

  describe "by_id/1" do
    test "returns a post if it exists" do
      user = insert(:user, Bcrypt.add_hash("123456"))
      post = insert(:post, %{user_id: user.id})

      response = Get.by_id(post.id)

      assert {:ok, %Post{}} = response
    end

    test "throws if trying to find a nonexistent post by its ID" do
      invalid_id = "b85d6624-5dd4-4379-b62a-a8b5414a5b8b"

      response = Get.by_id(invalid_id)

      assert {:error, %Error{result: "Post not found.", status: :not_found}} = response
    end
  end
end
