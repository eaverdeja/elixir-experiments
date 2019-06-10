defmodule ChatterWeb.RoomChannel do
  use ChatterWeb, :channel

  import Ecto.Query

  alias ChatterWeb.Presence
  alias Chatter.{Message, Repo}

  def join("room:lobby", _, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })

    push(socket, "presence_state", Presence.list(socket))
    push(socket, "message:all", %{"messages" => get_messages()})

    {:noreply, socket}
  end

  defp get_messages() do
    query =
      from m in Chatter.Message,
        join: u in "users",
        on: m.user_id == u.id,
        order_by: [asc: m.inserted_at],
        limit: 10,
        select: {u.email, m.message, m.inserted_at}

    Repo.all(query)
    |> Enum.map(fn {user, message, inserted_at} ->
      %{
        user: user,
        body: message,
        timestamp: to_string(inserted_at)
      }
    end)
  end

  def handle_in("message:new", message, socket) do
    query = from u in Chatter.User, where: u.email == ^socket.assigns.user

    case Repo.one(query) do
      nil ->
        {:stop, "User not found"}

      user ->
        changeset =
          Message.changeset(%Message{}, %{
            "user_id" => user.id,
            "message" => message
          })

        case Repo.insert(changeset) do
          {:ok, _message} ->
            broadcast!(socket, "message:new", %{
              user: socket.assigns.user,
              body: message,
              timestamp: :os.system_time(:milli_seconds)
            })

            {:noreply, socket}

          {:error, _changeset} ->
            {:stop, "Can't create message"}
        end
    end
  end
end
