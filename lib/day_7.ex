defmodule Day7 do
  @doc """
  iex> Day7.run_on_input(File.read!("inputs/day_7"))
  118
  """
  def run_on_input(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.filter(&supports_tls?/1)
    |> Enum.count
  end

  @doc """
  iex> Day7.supports_tls? "abba[mnop]qrst"
  true

  iex> Day7.supports_tls? "abcd[bddb]xyyx"
  false

  iex> Day7.supports_tls? "aaaa[qwer]tyui"
  false

  iex> Day7.supports_tls? "ioxxoj[asdfgh]zxcvbn"
  true
  """
  def supports_tls?(ip) do
    outsides = String.split(ip, ~r/\[[a-z]+\]/)
    insides = ~r/\[([a-z]+)\]/
    |> Regex.scan(ip)
    |> Enum.map(fn [_, v] -> v end)
    outsides_has_abba = outsides
    |> Enum.any?(fn inside ->
      inside |> find_groups_of(4) |> Enum.any?(&contains_abba?/1)
    end)
    insides_has_abba = insides
    |> Enum.any?(fn inside ->
      inside |> find_groups_of(4) |> Enum.any?(&contains_abba?/1)
    end)
    outsides_has_abba && not insides_has_abba
  end

  @doc """
  iex> Day7.find_groups_of("abcd", 4)
  ["abcd"]

  iex> Day7.find_groups_of("abcde", 4)
  ["bcde", "abcd"]

  iex> Day7.find_groups_of("abcd", 2)
  ["cd", "bc", "ab"]
  """
  def find_groups_of(letters, num \\ 4) do
    do_find_groups_of(letters, num, [])
  end
  defp do_find_groups_of(letters, num, acc) do
    if String.length(letters) === num do
      [letters | acc]
    else
      {_, new_letters} = String.split_at(letters, 1)
      do_find_groups_of(new_letters, num, [String.slice(letters, 0, num) | acc])
    end
  end

  @doc """
  iex> Day7.contains_abba?("abba")
  true

  iex> Day7.contains_abba?("cttc")
  true

  iex> Day7.contains_abba?("ctec")
  false

  iex> Day7.contains_abba?("ctta")
  false

  iex> Day7.contains_abba?("aaaa")
  false
  """
  def contains_abba?(<< a :: size(8), a :: size(8), a :: size(8), a :: size(8) >>), do: false
  def contains_abba?(<< a :: size(8), b :: size(8), b :: size(8), a :: size(8) >>), do: true
  def contains_abba?(_), do: false
end
