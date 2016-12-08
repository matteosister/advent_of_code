defmodule Day5 do

  @doc """
  iex Day5.find_password("abc")
  "18f47a30"

  iex Day5.find_password("cxdnnyjw")
  "f77a0e6e"
  """
  def find_password(input) do
    1..8
    |> Enum.reduce({"", 0}, fn _, {password, num} ->
      {last_num, char} = find_char(input, num)
      {"#{password}#{char}", last_num + 1}
    end)
    |> elem(0)
  end

  defp find_char(input, start_from) do
    hash = hash("#{input}#{start_from}")
    if String.starts_with?(hash, "00000") do
      {start_from, String.at(hash, 5)}
    else
      find_char(input, start_from + 1)
    end
  end

  @doc """
  iex Day5.find_password_with_position("abc")
  "05ace8e3"

  iex> Day5.find_password_with_position("cxdnnyjw")
  "999828ec"
  """
  def find_password_with_position(input) do
    1..8
    |> Enum.reduce({[], 0}, fn _, {chars, num} ->
      exclude = Enum.map(chars, &elem(&1, 0))
      {last_num, position, char} = find_char_and_position(input, num, exclude)
      {[{position, char} | chars], last_num + 1}
    end)
    |> elem(0)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.join
  end

  defp find_char_and_position(input, start_from, exclude_pos) do
    hash = hash("#{input}#{start_from}")
    if String.starts_with?(hash, "00000") do
      pos = String.at(hash, 5)
      case Integer.parse(pos) do
        {num, _} when num < 8 ->
          if num in exclude_pos do
            find_char_and_position(input, start_from + 1, exclude_pos)
          else
            {start_from, num, String.at(hash, 6)}
          end
        _ -> find_char_and_position(input, start_from + 1, exclude_pos)
      end
    else
      find_char_and_position(input, start_from + 1, exclude_pos)
    end
  end

  @doc """
  iex> Day5.hash("abc5017308")
  "000008f82c5b3924a1ecbebf60344e00"
  """
  def hash(input) do
    :md5
    |> :crypto.hash(String.to_charlist(input))
    |> Base.encode16
    |> String.downcase
  end
end
