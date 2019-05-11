defmodule Chat.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, [], opts)
  end

  def init(_) do
    children = [
      Chat.Server
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
