defmodule ChatServerWeb.Schema.UserTypes do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: ChatServer.Repo

  object :user do
    field :id, :id
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :inserted_at, :string
    field :updated_at, :string
    field :token, :string do
      resolve fn user, _, _ ->
        case ChatServer.Guardian.encode_and_sign(user) do
          {:ok, jwt, _ } -> {:ok, jwt}
          _ -> {:ok, nil}
        end
      end
    end
  end

  object :session do
    field :token, :string
  end

end