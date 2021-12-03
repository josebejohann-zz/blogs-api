defmodule BlogsAPIWeb.PostsControllerTest do
  use BlogsAPIWeb.ConnCase, async: true

  import BlogsAPI.Factory

  alias BlogsAPIWeb.Auth.Guardian

  describe "create/2" do
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

    test "creates a post when valid params are given", %{conn: conn, user: user} do
      params = build(:post_params, %{"userId" => user.id})

      response =
        conn
        |> post(Routes.posts_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "content" => "Content",
               "id" => _,
               "title" => "Title",
               "userId" => "fec137fd-fe09-4559-bde6-b1501606c76a"
             } = response
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

    test "returns an array containing all posts", %{conn: conn, user: user} do
      insert(:post, %{id: "fec137fd-fe09-4559-bde6-b1501606c76a", user_id: user.id})

      response =
        conn
        |> get(Routes.posts_path(conn, :index))
        |> json_response(:ok)

      assert [
               %{
                 "id" => "fec137fd-fe09-4559-bde6-b1501606c76a",
                 "content" => "Content",
                 "published" => _,
                 "title" => "Title",
                 "updated" => _,
                 "user" => %{
                   "displayName" => "Jane Smith",
                   "email" => "janesmith@email.com",
                   "id" => "fec137fd-fe09-4559-bde6-b1501606c76a",
                   "image" => "http://image.url/"
                 },
                 "user_id" => "fec137fd-fe09-4559-bde6-b1501606c76a"
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

    test "returns a post if it exists", %{conn: conn, user: user} do
      post = insert(:post, %{id: "fec137fd-fe09-4559-bde6-b1501606c76a", user_id: user.id})

      response =
        conn
        |> get(Routes.posts_path(conn, :show, post.id))
        |> json_response(:ok)

      assert %{
               "id" => "fec137fd-fe09-4559-bde6-b1501606c76a",
               "content" => "Content",
               "published" => _,
               "title" => "Title",
               "updated" => _,
               "user" => %{
                 "displayName" => "Jane Smith",
                 "email" => "janesmith@email.com",
                 "id" => "fec137fd-fe09-4559-bde6-b1501606c76a",
                 "image" => "http://image.url/"
               },
               "user_id" => "fec137fd-fe09-4559-bde6-b1501606c76a"
             } = response
    end
  end

  describe "update/2" do
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

    test "updates a post if it exists", %{conn: conn, user: user} do
      post = insert(:post, %{id: "fec137fd-fe09-4559-bde6-b1501606c76a", user_id: user.id})

      response =
        conn
        |> put(
          Routes.posts_path(conn, :update, post.id, %{
            title: "updated title",
            content: "updated content"
          })
        )
        |> json_response(:ok)

      assert %{
               "content" => "updated content",
               "id" => "fec137fd-fe09-4559-bde6-b1501606c76a",
               "title" => "updated title",
               "userId" => "fec137fd-fe09-4559-bde6-b1501606c76a"
             } = response
    end

    test "throws if nonauthorized user tries to update a post", %{conn: conn, user: user} do
      invalid_owner =
        insert(
          :user,
          Enum.concat(
            %{email: "invalid_owner@mail.com"},
            Bcrypt.add_hash("123456")
          )
        )

      post =
        insert(:post, %{
          id: "63619164-9254-4c8f-bb93-c80d80452ac7",
          user_id: user.id
        })

      {:ok, token, _claims} = Guardian.encode_and_sign(invalid_owner)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> put(Routes.posts_path(conn, :update, post.id))
        |> json_response(:unauthorized)

      assert %{"message" => "Unauthorized user."} = response
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

    test "deletes a post if it exists", %{conn: conn, user: user} do
      post = insert(:post, %{id: "fec137fd-fe09-4559-bde6-b1501606c76a", user_id: user.id})

      response =
        conn
        |> delete(Routes.posts_path(conn, :delete, post.id))
        |> response(:no_content)

      assert response == ""
    end

    test "throws if nonauthorized user tries to delete a post", %{conn: conn, user: user} do
      invalid_owner =
        insert(
          :user,
          Enum.concat(
            %{email: "invalid_owner@mail.com"},
            Bcrypt.add_hash("123456")
          )
        )

      post =
        insert(:post, %{
          id: "63619164-9254-4c8f-bb93-c80d80452ac7",
          user_id: user.id
        })

      {:ok, token, _claims} = Guardian.encode_and_sign(invalid_owner)

      response =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> delete(Routes.posts_path(conn, :delete, post.id))
        |> json_response(:unauthorized)

      assert %{"message" => "Unauthorized user."} = response
    end
  end
end
