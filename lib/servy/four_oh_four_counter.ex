defmodule Servy.FourOhFourCounter do
  alias Servy.GenericServer
  @name __MODULE__

  def start(initial_state \\ %{}) do
    if Mix.env() != :test do
      IO.puts("\nStarting 404 counter server")
    end

    GenericServer.start(__MODULE__, initial_state, @name)
  end

  def bump_count(path) do
    GenericServer.call(@name, {:bump_count, path})
  end

  def get_counts() do
    GenericServer.call(@name, :get_counts)
  end

  def get_count(path) do
    GenericServer.call(@name, {:get_count, path})
  end

  def reset() do
    GenericServer.cast(@name, :reset)
  end

  def handle_call({:bump_count, path}, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    count = Map.get(new_state, path)
    {count, new_state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_call({:get_count, path}, state) do
    count = Map.get(state, path, 0)
    {count, state}
  end

  def handle_cast(:reset, _state) do
    %{}
  end
end
