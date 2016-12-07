defmodule Day3 do
  @doc """
  iex> Day3.count_impossible_triangles ~s(10 20 15  \\n3  4  5)
  0

  iex> Day3.count_impossible_triangles ~s(10 20 15  \\n3  4  10)
  1

  iex> Day3.count_impossible_triangles File.read!("inputs/day_3")
  773
  """
  def count_impossible_triangles(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split/1)
    |> Stream.map(fn x -> Enum.map(x, &String.to_integer/1) end)
    |> Stream.reject(&(&1 === []))
    |> Enum.reject(&is_possible_triangle?/1)
    |> Enum.count
  end

  @doc """
  iex> Day3.is_possible_triangle?([10, 10, 10])
  true

  iex> Day3.is_possible_triangle?([5, 10, 12])
  true

  iex> Day3.is_possible_triangle?([5, 10, 25])
  false
  """
  def is_possible_triangle?([a, b, c]) do
    a < (b + c) && b < (a + c) && c < (a + b)
  end
end
