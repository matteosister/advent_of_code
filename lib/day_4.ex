defmodule Day4 do
  @doc """
  iex> Day4.run(File.read!("inputs/day_4"))
  278221
  """
  def run(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 === ""))
    |> sum_real_rooms_ids
  end

  @doc """
  iex> Day4.find_sector_id(File.read!("inputs/day_4"))
  267
  """
  def find_sector_id(input) do
    input
    |> String.split("\n")
    |> Enum.reject(&(&1 === ""))
    |> Enum.map(fn name ->
      {letters, room_id, _} = parts(name)
      {letters, room_id}
    end)
    |> Enum.map(fn {letters, room_id} ->
      {room_id, decipher_name(letters, room_id)}
    end)
    |> Enum.find(fn {room_id, name} ->
      name === "northpole object storage"
    end)
    |> elem(0)
  end

  @doc """
  iex> Day4.decipher_name("abc", 2)
  "cde"

  iex> Day4.decipher_name("xyz", 2)
  "zab"

  iex> Day4.decipher_name("xyz", 26)
  "xyz"

  iex> Day4.decipher_name("abc", 52)
  "abc"

  iex> Day4.decipher_name("abc-abc", 52)
  "abc abc"
  """
  def decipher_name(name, number) do
    name
    |> String.to_charlist
    |> Enum.map(fn
      ?-   -> " "
      char -> rem(char - ?a + number, ?z - ?a + 1) + ?a
    end)
    |> to_string
  end

  @doc """
  iex> Day4.sum_real_rooms_ids(["aaaaa-bbb-z-y-x-200[abxyz]", "a-b-c-d-e-f-g-h-100[abcde]"])
  300
  """
  def sum_real_rooms_ids(room_names) do
    room_names
    |> Enum.reduce(0, fn name, acc ->
      if real_room?(name) do
        {_, room_id, _} = parts(name)
        acc + room_id
      else
        acc
      end
    end)
  end

  @doc """
  iex> Day4.real_room?("aaaaa-bbb-z-y-x-123[abxyz]")
  true

  iex> Day4.real_room?("a-b-c-d-e-f-g-h-987[abcde]")
  true

  iex> Day4.real_room?("not-a-real-room-404[oarel]")
  true

  iex> Day4.real_room?("totally-real-room-200[decoy]")
  false
  """
  def real_room?(name) do
    {letters, _, checksum} = parts(name)
    checksum === compute_checksum(letters)
  end

  @doc """
  iex> Day4.parts("totally-real-room-200[decoy]")
  {"totally-real-room", 200, "decoy"}

  iex> Day4.parts("a-b-c-d-e-f-g-h-987[abcde]")
  {"a-b-c-d-e-f-g-h", 987, "abcde"}
  """
  def parts(name) do
    [_, letters, sector_id, checksum] = Regex.run(~r/^([a-z\-]+)(\d+)\[([a-z]+)\]$/, name)
    {String.trim_trailing(letters, "-"), String.to_integer(sector_id), checksum}
  end

  @doc """
  iex Day4.compute_checksum("aaaaa-bbb-z-y-x")
  "abxyz"

  iex Day4.compute_checksum("a-b-c-d-e-f-g-h")
  "abcde"

  iex> Day4.compute_checksum("not-a-real-room")
  "oarel"
  """
  def compute_checksum(letters) when is_binary(letters) do
    letters
    |> String.replace("-", "")
    |> String.to_charlist
    |> compute_checksum
  end
  def compute_checksum(letters) do
    letters
    |> Enum.group_by(&(&1))
    |> Enum.sort_by(&elem(&1, 1), fn first, second ->
      if Enum.count(first) != Enum.count(second) do
        Enum.count(first) >= Enum.count(second)
      else
        first < second
      end
    end)
    |> Stream.take(5)
    |> Stream.map(&(elem(&1, 1)))
    |> Stream.map(&to_string/1)
    |> Stream.map(&String.first/1)
    |> Enum.join
  end
end
