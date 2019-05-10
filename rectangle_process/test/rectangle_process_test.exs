defmodule RectangleProcessTest do
  use ExUnit.Case
  doctest RectangleProcess

  test "receives messages" do
    # Arrange
    a = spawn(fn -> RectangleProcess.area_loop() end)
    :erlang.trace(a, true, [:receive])
    msg = {:area, 200, 35}

    # Act
    send(a, msg)

    # Assert
    assert_receive {:trace, ^a, :receive, msg}
  end
end
