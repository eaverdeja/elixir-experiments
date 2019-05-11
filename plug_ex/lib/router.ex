defmodule PlugEx.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get("/", do: send_resp(conn, 200, "Hello There!"))

  get "/home" do
    conn
    |> put_resp_header("content-type", "text/html; chartset=utf-8")
    |> Plug.Conn.send_file(200, "lib/index.html")
  end

  get("/about/:user_name", do: send_resp(conn, 200, "Hey #{user_name}!"))

  match(_, do: send_resp(conn, 404, "404 Error - Page not found"))
end
