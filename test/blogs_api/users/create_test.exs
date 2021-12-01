defmodule BlogsAPI.Users.CreateTest do
  use BlogsAPI.DataCase, async: true
  import BlogsAPI.Factory
  alias BlogsAPI.{Error, User}
  alias BlogsAPI.Users.Create

  describe "call/1" do
    test "creates a user if correct params are given" do
      valid_params = build(:user)

      response = Create.call(valid_params)

      assert {:ok, %User{}} = response
    end

    test "throws when required params are not given" do
      invalid_required_params = build(:user, %{"email" => "", "password" => ""})

      response = Create.call(invalid_required_params)

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == %{email: ["can't be blank"], password: ["can't be blank"]}
    end

    test "throws when invalid params are given" do
      invalid_params = build(:user, %{"displayName" => "foo", "email" => "bar", "password" => "123"})

      response = Create.call(invalid_params)

      assert {:error, %Error{status: :bad_request, result: changeset}} = response

      assert errors_on(changeset) ==
        %{displayName: ["should be at least 8 character(s)"], email: ["has invalid format"], password: ["should be at least 6 character(s)"]}
    end

    test "throws when already taken e-mail is given" do
      Create.call(build(:user))

      already_taken_email = build(:user)

      response = Create.call(already_taken_email)

      assert {:error, %Error{status: :bad_request, result: changeset}} = response
      assert errors_on(changeset) == %{email: ["has already been taken"]}
    end
  end
end
