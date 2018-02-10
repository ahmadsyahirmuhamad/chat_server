defmodule ChatServer.Resolvers.UserResolver do

  # alias ChatServer.Account.User
  # alias ChatServer.Repo

  def current_user(_args, %{context: %{current_user: user }}) do
    if user do
      {:ok, user}
    else
      {:error, "Unauthenticate"}
    end
  end

end