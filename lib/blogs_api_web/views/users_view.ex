defmodule BlogsAPIWeb.UsersView do
  use BlogsAPIWeb, :view

  def render("create.json", %{token: token}) do
    %{
      token: token
    }
  end

  def render("index.json", %{users: users}) do
    users
  end
end
