alias ChatServer.Repo
alias ChatServer.Account.User

# Create users
user_params = %{
  email: "user_1@example.com",
  password: "password",
  password_confirmation: "password",
  first_name: "user",
  last_name: "example"
}
changeset = User.changeset(:create, %User{}, user_params)
Repo.insert(changeset)

