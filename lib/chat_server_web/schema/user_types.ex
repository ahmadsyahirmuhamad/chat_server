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
  end

end