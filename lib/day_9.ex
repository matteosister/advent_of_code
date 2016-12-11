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

  @doc """
  iex Day9.find_pwd_v2 "(3x3)XYZ"
  9

  iex Day9.find_pwd_v2 "X(8x2)(3x3)ABCY"
  20

  iex Day9.find_pwd_v2 "(27x12)(20x12)(13x14)(7x10)(1x12)A"
  241920

  iex> Day9.find_pwd_v2 "(19x14)(3x2)ZTN(5x14)MBPWH"
  1064

  iex> Day9.find_pwd_v2 "(19x14)(3x2)ZTN(5x14)MBPWH(112x2)(20x15)(2x15)AX(7x4)UDNOYNU(7x7)YGJJMBB(59x11)(1x10)Q(29x4)VGDXLQYSEUBZSCXVKJLIDXGHCSQXL(3x15)QMJ(2x15)GA(1x11)N"
  10000
  """
  def find_pwd_v2(input) do
    input
    |> tokenize([])
    |> Enum.map(&size_calculator/1)
    |> Enum.sum
  end

  def size_calculator(token) when is_binary(token), do: String.length(token)
  def size_calculator(token) when is_list(token), do: Enum.map(token, &size_calculator/1) |> Enum.sum
  def size_calculator({num, [subject]}) when is_binary(subject), do: num * String.length(subject)
  def size_calculator({num, subject}) do
    num * size_calculator(subject)
  end

  defp tokenize(input, acc) do
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
        {letters, rest_untouched} = String.split_at(rest, number_of_letters)
        acc = if start != "" do
          [start | acc]
        else
          acc
        end
        acc =
          case tokenize(letters, []) do
            [letters_tokenized] ->
              acc ++ [{repetitions, letters_tokenized}]
            letters_tokenized ->
              acc ++ [{repetitions, letters_tokenized}]
          end
        tokenize(rest_untouched, acc)
      nil ->
        if input === "" do
          acc
        else
          acc ++ [input]
        end
    end
  end
end
