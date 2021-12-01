defmodule BlogsAPI.Factory do
  use ExMachina.Ecto, repo: BlogsAPI.Repo

  def user_factory do
    %{
      "displayName" => "Jane Smith",
      "email" => "janesmith@email.com",
      "password" => "123456",
      "image" => "http://image.url/"
    }
  end
end
