alias ChatServer.Repo
alias ChatServer.Account.User

# Create users
user_one = %{
  email: "john_doe@example.com",
  password: "password",
  password_confirmation: "password",
  first_name: "john",
  last_name: "doe"
}
changeset = User.changeset(:create, %User{}, user_one)
Repo.insert(changeset)


user_two = %{
  email: "jane_doe@example.com",
  password: "password",
  password_confirmation: "password",
  first_name: "jane",
  last_name: "example"
}
changeset = User.changeset(:create, %User{}, user_two)
Repo.insert(changeset)
