defmodule Servy.Timer do
  def remind(message, timeInSeconds) do
    spawn(fn ->
      :timer.sleep(timeInSeconds * 1000)
      IO.puts(message)
    end)
  end
end

# Servy.Timer.remind("Stand Up", 5)
# Servy.Timer.remind("Sit Down", 6)
# Servy.Timer.remind("Fight, Fight, Fight", 7)
