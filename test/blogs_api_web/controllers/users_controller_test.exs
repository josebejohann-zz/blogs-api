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
  end

  describe "sign_in/2" do
    test "returns a JWT token when valid params are given", %{conn: conn} do
      user = insert(:user, Bcrypt.add_hash("123456"))

      response =
        conn
        |> post(
          Routes.users_path(conn, :sign_in, %{"email" => user.email, "password" => user.password})
        )
        |> json_response(:ok)

      assert %{"token" => _} = response
    end
  end

  describe "index/2" do
    setup %{conn: conn} do
      user =
        insert(
          :user,
          Enum.concat(
            %{id: "fec137fd-fe09-4559-bde6-b1501606c76a"},
            Bcrypt.add_hash("123456")
          )
        )

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "returns an array containing all registered users", %{conn: conn} do
      response =
        conn
        |> get(Routes.users_path(conn, :index))
        |> json_response(:ok)

      assert [
               %{
                 "displayName" => "Jane Smith",
                 "email" => "janesmith@email.com",
                 "id" => "fec137fd-fe09-4559-bde6-b1501606c76a",
                 "image" => "http://image.url/"
               }
             ] = response
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      user =
        insert(
          :user,
          Enum.concat(
            %{id: "fec137fd-fe09-4559-bde6-b1501606c76a"},
            Bcrypt.add_hash("123456")
          )
        )

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "returns a user if it exists", %{conn: conn, user: user} do
      response =
        conn
        |> get(Routes.users_path(conn, :show, user.id))
        |> json_response(:ok)

      assert %{
               "displayName" => "Jane Smith",
               "email" => "janesmith@email.com",
               "id" => "fec137fd-fe09-4559-bde6-b1501606c76a",
               "image" => "http://image.url/"
             } = response
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user =
        insert(
          :user,
          Enum.concat(
            %{id: "fec137fd-fe09-4559-bde6-b1501606c76a"},
            Bcrypt.add_hash("123456")
          )
        )

      {:ok, token, _claims} = Guardian.encode_and_sign(user)
      conn = put_req_header(conn, "authorization", "Bearer #{token}")

      {:ok, conn: conn, user: user}
    end

    test "deletes a user if it exists", %{conn: conn, user: user} do
      response =
        conn
        |> delete(Routes.users_path(conn, :delete, user.id))
        |> response(:no_content)

      assert response == ""
    end
  end
end
