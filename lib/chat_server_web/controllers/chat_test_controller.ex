defmodule ChatServerWeb.ChatTestController do
  use ChatServerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
