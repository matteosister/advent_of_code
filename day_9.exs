input = File.read!("inputs/day_9")
|> String.trim

IO.puts Day9.find_pwd(input) |> String.length
