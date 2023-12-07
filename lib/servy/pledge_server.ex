defmodule Servy.PledgeServer do
  @name __MODULE__

  # Client Interface Functions

  def start(initial_state \\ []) do
    if Mix.env() != :test do
      IO.puts("\nStarting pledge server")
    end

    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def create_pledge(name, amount) do
    # Sends the pledge to the external service
    send(@name, {self(), :create_pledge, name, amount})

    receive do
      {:response, status} ->
        status
    end
  end

  def recent_pledges() do
    # Gets the recent pledges from the cache
    send(@name, {self(), :recent_pledges})

    receive do
      {:response, pledges} ->
        pledges
    end
  end

  def total_pledged() do
    # Gets the recent pledges from the cache
    send(@name, {self(), :total_pledged})

    receive do
      {:response, total} ->
        total
    end
  end

  # Server Functions

  def listen_loop(state) do
    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(state, 2)
        new_state = [{name, amount} | most_recent_pledges]
        send(sender, {:response, id})
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        listen_loop(state)

      {sender, :total_pledged} ->
        total = Enum.map(state, &elem(&1, 1)) |> Enum.sum()
        send(sender, {:response, total})
        listen_loop(state)

      unexpected ->
        IO.puts("Unexpected message: #{inspect(unexpected)}")
        listen_loop(state)
    end
  end

  defp send_pledge_to_service(_name, _amount) do
    # Sends the pledge to the external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

# alias Servy.PledgeServer

# _pid = PledgeServer.start()

# IO.inspect(PledgeServer.create_pledge("larry", 10))
# IO.inspect(PledgeServer.create_pledge("moe", 20))
# IO.inspect(PledgeServer.create_pledge("curly", 30))
# IO.inspect(PledgeServer.create_pledge("daisy", 40))
# IO.inspect(PledgeServer.create_pledge("grace", 50))

# IO.inspect(PledgeServer.recent_pledges())
# IO.inspect(PledgeServer.total_pledged())
