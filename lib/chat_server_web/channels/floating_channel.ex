defmodule ChatServerWeb.FloatingChannel do
  use Phoenix.Channel
  require Logger

  # public channel
  def join("floating:msg", message, socket) do
    Process.flag(:trap_exit, true)
    :timer.send_interval(10000, :ping)
    send(self, {:after_join, message})

    {:ok, socket}
  end

  def join("rooms:" <> _private_subtopic, _message, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_info({:after_join, _msg}, socket) do
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
    broadcast! socket, "new:msg", %{id: msg["id"], user: msg["user"], body: msg["body"]}
    {:reply, {:ok, %{msg: msg["body"]}}, assign(socket, :user, msg["user"])}
  end

end