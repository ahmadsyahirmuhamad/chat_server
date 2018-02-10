defmodule ChatServerWeb.Context do

  @behaviour Plug

  import Plug.Conn
  # import Ecto.Query, only: [where: 2]

  # alias ChatServer.Repo
  # alias ChatServer.Account.User

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    put_private(conn, :absinthe, %{context: context})
  end

  # set current user
  def build_context(conn) do
    user = ChatServer.Guardian.Plug.current_resource(conn)
    if user do
      %{current_user: user}
    else
      %{current_user: nil}
    end
  end

end

