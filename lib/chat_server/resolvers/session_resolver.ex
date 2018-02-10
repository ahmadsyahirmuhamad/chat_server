defmodule ChatServer.Resolvers.SessionResolver do

  alias ChatServer.Repo
  # alias ChatServer.Account.User
  alias ChatServer.Auth.Auth

  def login(_parent, args, _context) do
    with {:ok, user} <- Auth.authenticate(args.email, args.password),
         {:ok, jwt, _ } <- ChatServer.Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt}}
    end
  end

end

