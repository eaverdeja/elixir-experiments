defmodule Gencounter.Application do
  use Application

  alias Gencounter.{Producer, ProducerConsumer, Consumer}

  def start(_type, _args) do
    children = [
      {Producer, 0},
      ProducerConsumer,
      Supervisor.child_spec(Consumer, id: :a),
      Supervisor.child_spec(Consumer, id: :b)
    ]

    opts = [strategy: :one_for_one, name: Gencounter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
