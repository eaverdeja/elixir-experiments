defmodule Chat.Server do
  use GenServer

  # Client side (invoked functions)

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: :chat_room)
  end

  def get_msgs do
    GenServer.call(:chat_room, :get_msgs)
  end

  def add_msg(msg) do
    GenServer.cast(:chat_room, {:add_msg, msg})
  end

  # Server side (callback functions)

  def init(msgs) do
    {:ok, msgs}
  end

  def handle_call(:get_msgs, _from, msgs) do
    {:reply, msgs, msgs}
  end

  def handle_cast({:add_msg, msg}, msgs) do
    {:noreply, [msg | msgs]}
  end
end
