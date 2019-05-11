defmodule Chat do
  use Application

  def start(_type, args) do
    Chat.Supervisor.start_link(args)
  end
end
