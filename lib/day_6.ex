defmodule Day6 do
  @doc """
  iex> Day6.run_on_input(File.read!("inputs/day_6"))
  "qqqluigu"
  """
  def run_on_input(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> find_message(fn list -> Enum.max_by(list, &(elem(&1, 0))) end)
  end

  @doc """
  iex> Day6.run_on_input_2(File.read!("inputs/day_6"))
  "lsoypmia"
  """
  def run_on_input_2(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> find_message(fn list -> Enum.min_by(list, &(elem(&1, 0))) end)
  end

  @doc """
  iex> Day6.find_message ~w(eedadn drvtee eandsr raavrd atevrs tsrnev sdttsa rasrtv nssdts ntnada svetve tesnvt vntsnd vrdear dvrsen enarar), fn list -> Enum.max_by(list, &(elem(&1, 0))) end
  "easter"

  iex> Day6.find_message ~w(eedadn drvtee eandsr raavrd atevrs tsrnev sdttsa rasrtv nssdts ntnada svetve tesnvt vntsnd vrdear dvrsen enarar), fn list -> Enum.min_by(list, &(elem(&1, 0))) end
  "advent"
  """
  def find_message(lines = [first | _], selector) do
    size = String.length(first)
    0..size-1
    |> Enum.map(fn pos ->
      lines
      |> Stream.map(&String.at(&1, pos))
      |> Enum.group_by(&(&1))
      |> Enum.map(fn {letter, occurrences} ->
        {Enum.count(occurrences), letter}
      end)
      |> selector.()
    end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.join
  end
end
