defmodule BlogsAPIWeb.UsersView do
  use BlogsAPIWeb, :view

  alias BlogsAPI.User

  def render("create.json", %{user: %User{} = user}) do
    %{
      user: user
    }
  end
end
