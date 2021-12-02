defmodule BlogsAPI.Factory do
  use ExMachina.Ecto, repo: BlogsAPI.Repo

  alias BlogsAPI.{User, Post}

  def user_params_factory do
    %{
      "displayName" => "Jane Smith",
      "email" => "janesmith@email.com",
      "password" => "123456",
      "image" => "http://image.url/"
    }
  end

  def user_factory do
    %User{
      displayName: "Jane Smith",
      email: "janesmith@email.com",
      password: "123456",
      image: "http://image.url/"
    }
  end

  def post_params_factory do
    %{
      "title" => "Title",
      "content" => "Content"
    }
  end

  def post_factory do
    %Post{
      title: "Title",
      content: "Content",
    }
  end
end
