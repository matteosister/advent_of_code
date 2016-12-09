defmodule Day8.Pixel do
  defstruct [:x, :y, on: false]
  def new(x, y) do
    %Day8.Pixel{x: x, y: y}
  end

  def turn_on(pixel), do: %{pixel | on: true}
  def turn_off(pixel), do: %{pixel | on: false}
end

defimpl String.Chars, for: Day8.Pixel do
  def to_string(%Day8.Pixel{on: true}), do: "X"
  def to_string(%Day8.Pixel{on: false}), do: "."
end

defmodule Day8.Screen do
  alias Day8.Pixel
  alias Day8.Screen

  defstruct [:w, :h, pixels: []]
  def new(w, h) do
    pixels = for x <- 0..w-1, y <- 0..h-1 do
      Pixel.new(x, y)
    end
    %Screen{w: w, h: h, pixels: pixels}
  end

  def count_lit_pixels(%Screen{pixels: pixels}) do
    pixels
    |> Enum.filter(&(&1.on))
    |> Enum.count
  end

  @doc """
  iex> Day8.Screen.get_row(Day8.Screen.new(2, 2), 0)
  [%Day8.Pixel{x: 0, y: 0}, %Day8.Pixel{x: 1, y: 0}]
  """
  def get_row(%Screen{pixels: pixels}, num) do
    pixels
    |> Enum.filter(&(&1.y === num))
  end

  @doc """
  iex> Day8.Screen.get_col(Day8.Screen.new(2, 2), 1)
  [%Day8.Pixel{x: 1, y: 0}, %Day8.Pixel{x: 1, y: 1}]
  """
  def get_col(%Screen{pixels: pixels}, num) do
    pixels
    |> Enum.filter(&(&1.x === num))
  end

  defp pixel_matcher(x, y) do
    fn
      %{x: ^x, y: ^y} -> true
      _ -> false
    end
  end

  def replace_pixels(screen = %Screen{pixels: pixels}, updated_pixels) do
    new_pixels = pixels
    |> Enum.map(fn old_pixel = %{x: x, y: y} ->
      Enum.find(updated_pixels, old_pixel, pixel_matcher(x, y))
    end)

    %{screen | pixels: new_pixels}
  end

  def rotate_col(screen = %Screen{pixels: pixels, h: h}, col_number) do
    new_col = screen
    |> get_col(col_number)
    |> Enum.map(&rotate_pixel(&1, :y, h))

    replace_pixels(screen, new_col)
  end

  def rotate_row(screen = %Screen{pixels: pixels, w: w}, row_number) do
    new_row = screen
    |> get_row(row_number)
    |> Enum.map(&rotate_pixel(&1, :x, w))

    replace_pixels(screen, new_row)
  end

  @doc """
  iex> Day8.Screen.rotate_pixel(%Day8.Pixel{x: 0, y: 0}, :y, 3)
  %Day8.Pixel{x: 0, y: 1}

  iex> Day8.Screen.rotate_pixel(%Day8.Pixel{x: 0, y: 2}, :y, 3)
  %Day8.Pixel{x: 0, y: 0}
  """
  def rotate_pixel(pixel, property, max) do
    actual = Map.get(pixel, property)
    Map.put(pixel, property, if actual === max - 1 do 0 else actual + 1 end)
  end

  @doc """
  iex> Day8.Screen.get_rect(Day8.Screen.new(3, 3), 2, 2)
  [%Day8.Pixel{x: 0, y: 0}, %Day8.Pixel{x: 0, y: 1},
   %Day8.Pixel{x: 1, y: 0}, %Day8.Pixel{x: 1, y: 1}]
  """
  def get_rect(%Screen{pixels: pixels}, x, y) do
    pixels
    |> Enum.filter(&(&1.x < x && &1.y < y))
  end

  def get_pixel(%Screen{pixels: pixels}, x, y) do
    pixels
    |> Enum.filter(&(&1.x === x && &1.y === y))
  end

  def draw(screen = %{w: w, h: h}) do
    0..h
    |> Enum.map(fn x ->
      get_row(screen, x) |> Enum.map(&IO.write/1)
      IO.puts ""
    end)
    screen
  end

  def execute(screen = %Screen{pixels: pixels}, "rect " <> size) do
    [w, h] = size
    |> String.split("x")
    |> Enum.map(&String.to_integer/1)
    new_pixels = pixels
    |> Enum.map(fn
      %{x: x, y: y} = pixel when x < w and y < h -> %{pixel | on: true}
      pixel -> pixel
    end)

    %{screen | pixels: new_pixels}
  end

  # rotate column x=1 by 1
  def execute(screen = %Screen{pixels: pixels}, "rotate column x=" <> spec) do
    [col, num] = spec
    |> String.split("by")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)

    Enum.reduce(1..num, screen, fn _, acc ->
      rotate_col(acc, col)
    end)
  end

  # rotate row y=0 by 4
  def execute(screen = %Screen{pixels: pixels}, "rotate row y=" <> spec) do
    [col, num] = spec
    |> String.split("by")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)

    Enum.reduce(1..num, screen, fn _, acc ->
      rotate_row(acc, col)
    end)
  end
end

defmodule Day8 do
  alias Day8.Screen

  def run do

  end
end
