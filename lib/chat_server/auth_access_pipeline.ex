defmodule ChatServer.AuthAccessPipeline do
  use Guardian.Plug.Pipeline, otp_app: :chat_server

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.VerifySession
  # plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource, allow_blank: true

  # conn.assigns.current_user
  plug ChatServer.Auth.Auth.CurrentUser

end
