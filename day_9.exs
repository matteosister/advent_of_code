input = File.read!("inputs/day_9")
|> String.trim

IO.puts Day9.find_pwd_v2(input)
