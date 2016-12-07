defmodule Day1 do
  @directions [:N, :E, :S, :W]

  @doc """
  iex> Day1.distance("R2, L3")
  5

  iex> Day1.distance("R2, R2, R2")
  2

  iex> Day1.distance("R5, L5, R5, R3")
  12

  iex> Day1.distance("R5, L2, L1, R1, R3, R3, L3, R3, R4, L2, R4, L4, R4, R3, L2, L1, L1, R2, R4, R4, L4, R3, L2, R1, L4, R1, R3, L5, L4, L5, R3, L3, L1, L1, R4, R2, R2, L1, L4, R191, R5, L2, R46, R3, L1, R74, L2, R2, R187, R3, R4, R1, L4, L4, L2, R4, L5, R4, R3, L2, L1, R3, R3, R3, R1, R1, L4, R4, R1, R5, R2, R1, R3, L4, L2, L2, R1, L3, R1, R3, L5, L3, R5, R3, R4, L1, R3, R2, R1, R2, L4, L1, L1, R3, L3, R4, L2, L4, L5, L5, L4, R2, R5, L4, R4, L2, R3, L4, L3, L5, R5, L4, L2, R3, R5, R5, L1, L4, R3, L1, R2, L5, L1, R4, L1, R5, R1, L4, L4, L4, R4, R3, L5, R1, L3, R4, R3, L2, L1, R1, R2, R2, R2, L1, L1, L2, L5, L3, L1")
  287
  """
  def distance(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce([%{dir: :N, x: 0, y: 0}], &move/2)
    |> compute_distance
  end

  @doc """
  iex> Day1.first_twice_location("R8, R4, R4, R8")
  4

  iex> Day1.first_twice_location("R5, L2, L1, R1, R3, R3, L3, R3, R4, L2, R4, L4, R4, R3, L2, L1, L1, R2, R4, R4, L4, R3, L2, R1, L4, R1, R3, L5, L4, L5, R3, L3, L1, L1, R4, R2, R2, L1, L4, R191, R5, L2, R46, R3, L1, R74, L2, R2, R187, R3, R4, R1, L4, L4, L2, R4, L5, R4, R3, L2, L1, R3, R3, R3, R1, R1, L4, R4, R1, R5, R2, R1, R3, L4, L2, L2, R1, L3, R1, R3, L5, L3, R5, R3, R4, L1, R3, R2, R1, R2, L4, L1, L1, R3, L3, R4, L2, L4, L5, L5, L4, R2, R5, L4, R4, L2, R3, L4, L3, L5, R5, L4, L2, R3, R5, R5, L1, L4, R3, L1, R2, L5, L1, R4, L1, R5, R1, L4, L4, L4, R4, R3, L5, R1, L3, R4, R3, L2, L1, R1, R2, R2, R2, L1, L1, L2, L5, L3, L1")
  133
  """
  def first_twice_location(input) do
    input
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce([%{dir: :N, x: 0, y: 0}], &move/2)
    |> Enum.reverse
    |> do_first_twice_location
    |> compute_distance
  end

  defp do_first_twice_location([actual = %{x: x, y: y} | others]) do
    if Enum.find(others, &(&1.x == x && &1.y == y)) do
      actual
    else
      do_first_twice_location(others)
    end
  end

  @doc """
  iex> Day1.move("R1", [%{dir: :N, x: 0, y: 0}])
  [%{dir: :E, x: 0, y: 1}, %{dir: :N, x: 0, y: 0}]

  iex> Day1.move("R2", [%{dir: :E, x: 0, y: 1}])
  [%{dir: :S, x: -2, y: 1}, %{dir: :S, x: -1, y: 1}, %{dir: :E, x: 0, y: 1}]
  """
  def move(<< turn_to::binary-size(1), steps::binary >>, acc = [pos = %{dir: dir} | _]) do
    new_position = change_direction(dir, turn_to)
    do_move(pos, new_position, String.to_integer(steps), acc)
  end

  defp do_move(pos = %{x: x}, :N, 1, acc), do: [%{pos | dir: :N, x: x + 1} | acc]
  defp do_move(pos = %{x: x}, :S, 1, acc), do: [%{pos | dir: :S, x: x - 1} | acc]
  defp do_move(pos = %{y: y}, :E, 1, acc), do: [%{pos | dir: :E, y: y + 1} | acc]
  defp do_move(pos = %{y: y}, :W, 1, acc), do: [%{pos | dir: :W, y: y - 1} | acc]
  defp do_move(pos, dir, steps, acc) do
    [new_pos] = do_move(pos, dir, 1, [])
    do_move(new_pos, dir, steps - 1, [new_pos | acc])
  end

  @doc """
  iex> Day1.change_direction(:N, "R")
  :E

  iex> Day1.change_direction(:E, "R")
  :S

  iex> Day1.change_direction(:E, "L")
  :N

  iex> Day1.change_direction(:E, "R")
  :S

  iex> Day1.change_direction(:W, "R")
  :N
  """
  def change_direction(dir, "R") do
    index = Enum.find_index(@directions, &(&1 === dir))
    new_index = new_index(index + 1)
    Enum.at(@directions, new_index)
  end

  def change_direction(dir, "L") do
    index = Enum.find_index(@directions, &(&1 === dir))
    new_index = new_index(index - 1)
    Enum.at(@directions, new_index)
  end

  @doc """
  iex> Day1.new_index(1)
  1

  iex> Day1.new_index(5)
  1

  iex> Day1.new_index(-1)
  3
  """
  def new_index(num) when num > 3, do: new_index(num - 4)
  def new_index(num) when num < 0, do: new_index(num + 4)
  def new_index(num), do: num

  def compute_distance(locations) when is_list(locations) do
    locations
    |> Enum.at(0)
    |> compute_distance
  end
  def compute_distance(%{x: x, y: y}), do: abs(x) + abs(y)
end
