defmodule BlogsAPIWeb.UsersControllerTest do
  use BlogsAPIWeb.ConnCase, async: true

  import BlogsAPI.Factory

  alias BlogsAPIWeb.Auth.Guardian

  describe "create/2" do
    test "creates a user when valid params are given", %{conn: conn} do
      params = build(:user_params)

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{"token" => _} = response
    end

    test "throws when invalid params are given", %{conn: conn} do
      params = build(:user_params, %{"displayName" => "Foo", "email" => "Bar", "password" => "1234"})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      assert %{"message" => ["displayName should be at least 8 character(s)", "email has invalid format", "password should be at least 6 character(s)"]} = response
    end

    test "throws when required params are not given", %{conn: conn} do
      params = build(:user_params, %{"email" => "", "password" => ""})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      %{"message" => ["email can't be blank", "password can't be blank"]} = response
    end

    test "throws when trying to create a user using already taken email", %{conn: conn} do
      user = insert(:user, Bcrypt.add_hash("123456"))
      params = build(:user_params, %{"email" => user.email})

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      %{"message" => ["email has already been taken"]} = response
    end
  end

  describe "sign_in/2" do
    test "returns a JWT token when valid params are given", %{conn: conn} do
      user = insert(:user, Bcrypt.add_hash("123456"))

      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, %{"email" => user.email, "password" => user.password}))
        |> json_response(:ok)

      assert %{"token" => _} = response
    end

    test "throws when an invalid email is passed", %{conn: conn} do
      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, %{"email" => "invalid_email", "password" => "any_password"}))
        |> json_response(:not_found)

      assert %{"message" => "User not found."} = response
    end

    test "throws when an invalid password is passed", %{conn: conn} do
      response =
        conn
        |> post(Routes.users_path(conn, :sign_in, %{"email" => "any_email", "password" => "any_password"}))
        |> json_response(:not_found)

      assert %{"message" => "User not found."} = response
    end
  end

  describe "index/2" do
    setup %{conn: conn} do
      user = insert(:user, Bcrypt.add_hash("123456"))
      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn}
    end

    test "list all users if authenticated", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :index))
        |> json_response(:ok)
    end

    test "throws if not authenticated", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "")

      response =
        conn
        |> get(Routes.users_path(conn, :index))
        |> json_response(:unauthorized, %{"message" => "foo"})

      assert response == "foo"
    end
  end
end
