defmodule Servy.KickStarter do
  use GenServer

  def start do
    if Mix.env() != :test do
      IO.puts("Starting #{__MODULE__}")
    end

    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HTTP server died with reason: #{inspect(reason)}")
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server() do
    if Mix.env() != :test do
      IO.puts("Starting HTTP server...")
    end

    server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
