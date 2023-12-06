power_nap = fn ->
  time = :rand.uniform(10_000)
  :timer.sleep(time)
  time
end

parent = self()
spawn(fn -> send(parent, {:result, power_nap.()}) end)
receive do
  {:result, time} -> IO.puts("Slept for #{time} milliseconds")
end
