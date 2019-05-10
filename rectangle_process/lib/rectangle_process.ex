defmodule RectangleProcess do
  @moduledoc """

  ## Use as such:

  - Spawn a new process and call the area_loop function

  ```elixir
  a = spawn(fn -> Rectangle.area_loop() end)
  ```
  - Send a message to the "a" process

  ```elixir
  send(a, {:area, 35, 200})
  > Area = 7000
  ```
  """

  def area_loop do
    receive do
      {:area, w, h} ->
        IO.puts("Area = #{w * h}")
        area_loop()

      {:pmeter, w, h} ->
        IO.puts("pmeter = #{w + h}")
        area_loop()
    end
  end
end
