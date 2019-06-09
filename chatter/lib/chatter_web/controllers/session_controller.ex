defmodule ChatterWeb.SessionController do
  use ChatterWeb, :controller

  alias ChatterWeb.Auth.Guardian
  alias Chatter.User

  require Logger

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})

    render(
      conn,
      "new.html",
      changeset: changeset,
      action: Routes.session_path(conn, :create)
    )
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    Chatter.User.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.session_path(conn, :new))
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: Routes.page_path(conn, :index))
  end

  defp login_reply({:error, _reason}, conn) do
    conn
    |> put_flash(:error, "Invalid credentials")
    |> new(%{})
  end
end
