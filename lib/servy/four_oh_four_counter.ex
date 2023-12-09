defmodule Servy.FourOhFourCounter do
  @name __MODULE__

  use GenServer

  def start_link(_args) do
    if Mix.env() != :test do
      IO.puts("\nStarting 404 counter server")
    end
    initial_state = %{}
    GenServer.start_link(__MODULE__, initial_state, name: @name)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def bump_count(path) do
    GenServer.call(@name, {:bump_count, path})
  end

  def get_counts() do
    GenServer.call(@name, :get_counts)
  end

  def get_count(path) do
    GenServer.call(@name, {:get_count, path})
  end

  def reset() do
    GenServer.cast(@name, :reset)
  end

  def handle_call({:bump_count, path}, _from, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    count = Map.get(new_state, path)
    {:reply, count, new_state}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_count, path}, _from, state) do
    count = Map.get(state, path, 0)
    {:reply, count, state}
  end

  def handle_cast(:reset, _state) do
    {:noreply, %{}}
  end
end
