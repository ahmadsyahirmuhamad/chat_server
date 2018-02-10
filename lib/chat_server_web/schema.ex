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

end