defmodule ChatterWeb.Auth.ErrorHandler do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import ChatterWeb.Router.Helpers, only: [session_path: 2]

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_flash(:error, "You must login to access this page!")
    |> redirect(to: session_path(conn, :new))
    |> halt()
  end
end
