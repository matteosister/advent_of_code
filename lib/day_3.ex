defmodule Day3 do
  @doc """
  iex> Day3.count_possible_triangles ~s(10 20 15  \\n3  4  5)
  2

  iex> Day3.count_possible_triangles ~s(10 20 15  \\n3  4  10)
  1

  iex> Day3.count_possible_triangles ~s(10 20 15  \\n3  4  10\\n 300 400 1000)
  1

  iex> Day3.count_possible_triangles File.read!("inputs/day_3")
  862
  """
  def count_possible_triangles(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split/1)
    |> Stream.map(fn x -> Enum.map(x, &String.trim/1) end)
    |> Stream.map(fn x -> Enum.map(x, &String.to_integer/1) end)
    |> Enum.reject(&(&1 === []))
    |> Enum.filter(&is_possible_triangle?/1)
    |> Enum.count
  end

  @doc """
  iex> Day3.count_possible_triangles_in_columns ~s(10 20 15  \\n3  4  10\\n3 10 20)
  1

  iex> Day3.count_possible_triangles_in_columns ~s(5 5 5  \\n5  20  5\\n5 20 4\\n6 6 6  \\n6  21  6\\n6 21 5)
  6

  iex> Day3.count_possible_triangles_in_columns File.read!("inputs/day_3")
  1577
  """
  def count_possible_triangles_in_columns(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.split/1)
    |> Stream.map(fn x -> Enum.map(x, &String.trim/1) end)
    |> Stream.map(fn x -> Enum.map(x, &String.to_integer/1) end)
    |> Enum.reject(&(&1 === []))
    |> Enum.reduce([[]], fn
      triangle, [[] | others] ->
        [[triangle] | others]
      triangle, acc = [actual | others] ->
        if Enum.count(actual) < 3 do
          [[triangle | actual] | others]
        else
          [[triangle] | acc]
        end
    end)
    |> Enum.flat_map(fn [[a1, a2, a3], [b1, b2, b3], [c1, c2, c3]] ->
      [[a1, b1, c1], [a2, b2, c2], [a3, b3, c3]]
    end)
    #|> IO.inspect
    |> Enum.filter(&is_possible_triangle?/1)
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
    (b + c) > a && (a + c) > b && (a + b) > c
  end
end
