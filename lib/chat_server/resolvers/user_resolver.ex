defmodule ChatServer.Resolvers.UserResolver do

  alias ChatServer.Account.User
  alias ChatServer.Repo

  def current_user(_args, %{context: %{current_user: user }}) do
    if user do
      {:ok, user}
    else
      {:error, "Unauthenticate"}
    end
  end

  def create_user(_parent, args, _context) do
    changeset = User.changeset(:create, %User{}, args)

    case changeset.valid? do
      true -> case Repo.insert(changeset) do
                {:ok, user} -> {:ok, user}
                _ -> {:error, "Database Error"}
              end
      false -> {:error, "Changeset Error"}
    end
  end

end

