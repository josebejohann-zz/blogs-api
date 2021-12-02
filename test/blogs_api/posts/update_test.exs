defmodule BlogsAPI.Posts.UpdateTest do
  use BlogsAPI.DataCase, async: true

  import BlogsAPI.Factory

  alias BlogsAPI.{Error, Post}
  alias BlogsAPI.Posts.Update

  describe "call/1" do
    test "updates a post if valid params are given" do
      user = insert(:user, Bcrypt.add_hash("123456"))
      post = insert(:post, %{user_id: user.id})

      valid_params = %{"id" => post.id, "title" => "Updated title", "content" => "Updated content"}

      response = Update.call(valid_params)

      assert {:ok, %Post{title: "Updated title", content: "Updated content"}} = response
    end

    test "throws if required params are not given" do
      user = insert(:user, Bcrypt.add_hash("123456"))
      post = insert(:post, %{user_id: user.id})

      invalid_params = %{"id" => post.id, "title" => "", "content" => ""}

      response = Update.call(invalid_params)

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == %{title: ["can't be blank"], content: ["can't be blank"]}
    end

    test "throws if trying to update a nonexistent post" do
      user = insert(:user, Bcrypt.add_hash("123456"))

      invalid_id = "f2dd9af7-6fd9-4a59-b0cc-4aa7c4f779aa"
      nonexistent_post = build(:post_params, %{"id" => invalid_id, "user_id" => user.id})

      response = Update.call(nonexistent_post)

      assert {:error, %Error{status: :not_found, result: "Post not found."}} = response
    end
  end
end
