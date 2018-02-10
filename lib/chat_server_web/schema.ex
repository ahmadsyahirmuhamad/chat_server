defmodule ChatServerWeb.Schema do

  use Absinthe.Schema

  import_types ChatServerWeb.Schema.UserTypes

  alias ChatServer.Resolvers

  query do

    @desc "Get current user"
    field :current_user, type: :user do
      resolve &Resolvers.UserResolver.current_user/2
    end

  end

  mutation do

    @desc "Register user"
    field :register_user, type: :user do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      arg :password_confirmation, non_null(:string)
      arg :first_name, non_null(:string)
      arg :last_name, non_null(:string)

      resolve &Resolvers.UserResolver.create_user/3
    end

    @desc "Login user"
    field :login, type: :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &Resolvers.SessionResolver.login/3
    end

  end

end