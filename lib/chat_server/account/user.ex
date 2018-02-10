defmodule ChatServer.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias ChatServer.Account.User


  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false

  def changeset(:create, struct, params) do
    struct
    |> cast(attrs, [:email, :first_name, :last_name, :password_hash])
    |> validate_required([:email, :first_name, :last_name, :password_hash])
    |> unique_constraint(:email)
    |> validate_confirmation(:password)
    |> generate_password_hash()
  end

  defp generate_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      pw -> put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pw))
    end
  end
end
