defmodule ChatServerWeb.Api.SessionController do

  use ChatServerWeb, :controller
  alias ChatServer.Auth.Auth

  require Logger

  def current(conn) do
    user = ChatServer.Guardian.Plug.current_resource(conn)
    jwt = ChatServer.Guardian.Plug.current_token(conn)
    claims = ChatServer.Guardian.Plug.current_claims(conn)
    exp = Map.get(claims, "exp")

    conn
    |> put_resp_header("x-expires", to_string(exp))
    |> put_resp_header("authorization", "Bearer #{jwt}")
    |> json(%{
      "token" => jwt,
      "email" => user.email,
      "id" => user.id,
    })
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Auth.authenticate(email, password) do
      {:ok, user} ->
        success(conn, user)
      {:error, error} ->
        failure(conn, error)
    end
  end

  defp success(conn, user) do
    Logger.debug("Responding SUCCESS via JSON")
    conn
    |> ChatServer.Guardian.Plug.sign_in(user)
    |> put_status(201)
    |> current()
  end

  defp failure(conn, error) do
    Logger.debug("Responding ERROR via JSON")
    conn
    |> put_status(401)
    |> json(%{ "message" => "Invalid email or password #{error}" })
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{ "error" => "Unauthenticated" })
  end

end
