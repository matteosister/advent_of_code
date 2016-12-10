defmodule Day9 do
  @doc """
  iex> Day9.find_pwd "ADVENT"
  "ADVENT"

  iex> Day9.find_pwd "A(1x5)BC"
  "ABBBBBC"

  iex> Day9.find_pwd "(3x3)XYZ"
  "XYZXYZXYZ"

  iex> Day9.find_pwd "A(2x2)BCD(2x2)EFG"
  "ABCBCDEFEFG"

  iex> Day9.find_pwd "(6x1)(1x3)A"
  "(1x3)A"

  iex> Day9.find_pwd "X(8x2)(3x3)ABCY"
  "X(3x3)ABC(3x3)ABCY"
  """
  def find_pwd(input) do
    case Regex.run ~r/\(\d*x\d*\)/, input, return: :index do
      [{pos, len}] ->
        [number_of_letters, repetitions] = input
        |> String.slice(pos, len)
        |> String.trim(")")
        |> String.trim("(")
        |> String.split("x")
        |> Enum.map(&String.to_integer/1)
        start = String.slice(input, 0, pos)
        {_, rest} = String.split_at(input, pos + len)
        {_, rest_untouched} = String.split_at(rest, number_of_letters)
        start
          <> String.duplicate(String.slice(rest, 0..number_of_letters-1), repetitions)
          <> find_pwd(rest_untouched)
      nil ->
        input
    end

  end
end
