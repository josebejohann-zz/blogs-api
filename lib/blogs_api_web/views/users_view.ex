defmodule BlogsAPIWeb.UsersView do
  use BlogsAPIWeb, :view

  alias BlogsAPI.User

  def render("create.json", %{token: token}) do
    %{
      token: token
    }
  end
end
