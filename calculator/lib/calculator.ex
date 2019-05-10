defmodule Calculator do
  @moduledoc """
  Operates on a stored value with + - * /
  """

  # Server

  def start do
    spawn(fn -> loop(0) end)
  end

  defp loop(current_value) do
    new_value =
      receive do
        {:value, client_id} ->
          send(client_id, {:response, current_value})
          current_value

        {:add, value} ->
          current_value + value

        {:sub, value} ->
          current_value - value

        {:mult, value} ->
          current_value * value

        {:div, value} ->
          current_value / value

        invalid_request ->
          IO.puts("Invalid Request #{inspect(invalid_request)}")
      end

    loop(new_value)
  end

  # Client

  @doc """
  Asks the server for the current value
  and prints it out
  """
  def value(server_id) do
    send(server_id, {:value, self()})

    receive do
      {:response, value} ->
        value
    end
  end

  @doc """
  Sends a sum operation to the calculator
  and returns the result
  """
  def add(server_id, value) do
    send(server_id, {:add, value})
    value(server_id)
  end

  @doc """
  Sends a subtractin operation to the calculator
  and returns the result
  """
  def sub(server_id, value) do
    send(server_id, {:sub, value})
    value(server_id)
  end

  @doc """
  Sends a multiplication operation to the calculator
  and returns the result
  """
  def mult(server_id, value) do
    send(server_id, {:mult, value})
    value(server_id)
  end

  @doc """
  Sends a division operation to the calculator
  and returns the result
  """
  def div(server_id, value) do
    send(server_id, {:div, value})
    value(server_id)
  end
end
