defmodule BlogsAPIWeb.Auth.ErrorHandler do
  alias Guardian.Plug.ErrorHandler
  alias Plug.Conn

  @behaviour ErrorHandler

  def auth_error(conn, {_error, _reason}, _opts) do
    body = Jason.encode!(%{message: "Expired or invalid token."})

    Conn.send_resp(conn, 401, body)
  end
end
