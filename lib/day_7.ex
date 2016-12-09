defmodule Day7 do
  @doc """
  iex> Day7.input_supports_tls(File.read!("inputs/day_7"))
  118
  """
  def input_supports_tls(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.filter(&supports_tls?/1)
    |> Enum.count
  end

  @doc """
  iex> Day7.input_supports_ssl(File.read!("inputs/day_7"))
  260
  """
  def input_supports_ssl(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 == ""))
    |> Enum.filter(&supports_ssl?/1)
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
  iex> Day7.supports_ssl? "aba[bab]xyz"
  true

  iex> Day7.supports_ssl? "xyx[xyx]xyx"
  false

  iex> Day7.supports_ssl? "aaa[kek]eke"
  true

  iex> Day7.supports_ssl? "zazbz[bzb]cdb"
  true
  """
  def supports_ssl?(ip) do
    outsides = String.split(ip, ~r/\[[a-z]+\]/)
    insides = ~r/\[([a-z]+)\]/
    |> Regex.scan(ip)
    |> Enum.map(fn [_, v] -> v end)

    outside_aba = outsides
    |> Enum.flat_map(&find_groups_of(&1, 3))
    |> Enum.map(&get_aba/1)
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn [a, b, _] -> [b, a, b] end)

    inside_aba = insides
    |> Enum.flat_map(&find_groups_of(&1, 3))
    |> Enum.map(&get_aba/1)
    |> Enum.reject(&is_nil/1)

    outside_aba
    |> Enum.any?(&(&1 in inside_aba))
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

  @doc """
  iex> Day7.get_aba("aba")
  'aba'

  iex> Day7.get_aba("ctc")
  'ctc'

  iex> Day7.get_aba("cts")
  nil

  iex> Day7.get_aba("cta")
  nil

  iex> Day7.get_aba("aaa")
  nil
  """
  def get_aba(<< a :: size(8), a :: size(8), a :: size(8) >>), do: nil
  def get_aba(<< a :: size(8), b :: size(8), a :: size(8) >>), do: [a, b, a]
  def get_aba(_), do: nil
end
