alias Day8.Screen

# screen = Screen.new(7, 3)
# screen
# |> Screen.draw
# |> Screen.execute("rect 3x2")
# |> Screen.draw
# |> Screen.execute("rotate column x=1 by 1")
# |> Screen.draw
# |> Screen.execute("rotate row y=0 by 4")
# |> Screen.draw
# |> Screen.execute("rotate column x=1 by 1")
# |> Screen.draw

inputs = File.read!("inputs/day_8")
|> String.trim
|> String.split("\n")

s = Screen.new(50, 6)
Screen.draw(s)
s = Enum.reduce(inputs, s, fn instruction, s ->
  Screen.execute(s, instruction)
end)
Screen.draw(s)
IO.puts Screen.count_lit_pixels(s)
