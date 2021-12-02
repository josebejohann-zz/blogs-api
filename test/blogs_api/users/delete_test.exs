defmodule BlogsAPI.Users.DeleteTest do
  use BlogsAPI.DataCase, async: true

  import BlogsAPI.Factory

  alias BlogsAPI.{Error, Repo}
  alias BlogsAPI.Users.Delete

  describe "call/1" do
    test "deletes a user if it exists" do
      user = insert(:user, Bcrypt.add_hash("123456"))

      response = Delete.call(user.id)

      assert {:ok, _} = response
    end

    test "throws if trying to delete a nonexistent user" do
      invalid_id = "9c3ba2d0-c620-47fe-b2bc-947f197f0fec"
      response = Delete.call(invalid_id)

      assert {:error, %Error{result: "User not found.", status: :not_found}} = response
    end
  end
end
