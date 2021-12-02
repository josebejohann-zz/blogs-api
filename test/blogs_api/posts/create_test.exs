defmodule BlogsAPI.Posts.CreateTest do
  use BlogsAPI.DataCase, async: true

  import BlogsAPI.Factory

  alias BlogsAPI.{Error, Post}
  alias BlogsAPI.Posts.Create

  describe "call/1" do
    setup do
      user = insert(:user, Bcrypt.add_hash("123456"))

      {:ok, %{id: user.id}}
    end

    test "creates a post if correct params are given", %{id: id} do
      valid_params = build(:post_params, %{"user_id" => id})

      response = Create.call(valid_params)

      assert {:ok, %Post{}} = response
    end

    test "throws if required params are not given" do
      invalid_params = build(:post_params, %{"title" => "", "content" => "", "user_id" => ""})

      response = Create.call(invalid_params)

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == %{title: ["can't be blank"], content: ["can't be blank"], user_id: ["can't be blank"]}
    end

    test "throws if trying to create a post using invalid user ID" do
      invalid_user_id = "f2dd9af7-6fd9-4a59-b0cc-4aa7c4f779aa"
      post = build(:post_params, %{"user_id" => invalid_user_id})

      response = Create.call(post)

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == %{user_id: ["does not exist"]}
    end
  end
end
