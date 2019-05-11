defmodule Gencounter.Producer do
  use GenStage

  def start_link(init \\ 0) do
    GenStage.start_link(__MODULE__, init, name: __MODULE__)
  end

  @spec init(any()) :: {:producer, any()}
  def init(counter), do: {:producer, counter}

  @spec handle_demand(pos_integer(), integer()) :: {:noreply, [any()], integer()}
  def handle_demand(demand, state) when demand > 0 do
    events = Enum.to_list(state..(state + demand - 1))
    {:noreply, events, state + demand}
  end
end
