defmodule BlogsAPI.Posts.DeleteTest do
  use BlogsAPI.DataCase, async: true

  import BlogsAPI.Factory

  alias BlogsAPI.Error
  alias BlogsAPI.Posts.Delete

  describe "call/1" do
    test "deletes a post if it exists" do
      user = insert(:user, Bcrypt.add_hash("123456"))
      post = insert(:post, %{user_id: user.id})

      response = Delete.call(post.id)

      assert {:ok, _} = response
    end

    test "throws if tyring to delete a nonexistent post" do
      invalid_id = "f2dd9af7-6fd9-4a59-b0cc-4aa7c4f779aa"

      response = Delete.call(invalid_id)

      assert {:error, %Error{result: "Post not found.", status: :not_found}} = response
    end
  end
end
