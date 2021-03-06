defmodule ChatServerWeb.RoomChannel do
  use Phoenix.Channel
  require Logger

  # private channel
  def join("rooms:" <> private_subtopic, message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(10000, :ping)
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def join("rooms:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, msg}, socket) do
    broadcast! socket, "user:entered", %{user: msg["user"]}
    push socket, "join", %{status: "connected"}
    {:noreply, socket}
  end

  # ping event
  def handle_info(:ping, socket) do
    push socket, "ping:msg", %{user: "SYSTEM", body: "ping"}
    {:noreply, socket}
  end

  # terminate
  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  # event
  def handle_in("new:msg", msg, socket) do
    ChatServerWeb.Endpoint.broadcast("floating:msg", "new:msg", msg) # send to floating channel
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end

end