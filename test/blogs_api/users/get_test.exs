defmodule BlogsAPI.Users.GetTest do
  use BlogsAPI.DataCase, async: true

  import BlogsAPI.Factory

  alias BlogsAPI.{Error, User}
  alias BlogsAPI.Users.Get

  describe "call/0" do
    setup do
      user = insert(:user, Bcrypt.add_hash("123456"))

      {:ok, user: user}
    end

    test "returns all users" do
      response = Get.call()

      assert {:ok, [%User{}]} = response
    end

    test "returns an empty array if no user is registered" do
      Repo.delete_all(User)

      assert {:ok, []} = Get.call()
    end
  end

  describe "by_id/1" do
    test "returns a user if it exists" do
      user = insert(:user, Bcrypt.add_hash("123456"))

      response = Get.by_id(user.id)

      assert {:ok, %User{}} = response
    end

    test "throws if trying to find a nonexistent user by its ID" do
      invalid_id = "b85d6624-5dd4-4379-b62a-a8b5414a5b8b"

      response = Get.by_id(invalid_id)

      assert {:error, %Error{result: "User not found.", status: :not_found}} = response
    end
  end

  describe "by_email/1" do
    test "returns a user if it exists" do
      user = insert(:user, Bcrypt.add_hash("123456"))

      response = Get.by_email(user.email)

      assert {:ok, %User{}} = response
    end

    test "throws if trying to find a nonexistent user by its email" do
      invalid_email = "invalid_email@example.com"

      response = Get.by_email(invalid_email)

      assert {:error, %Error{result: "User not found.", status: :not_found}} = response
    end
  end
end
