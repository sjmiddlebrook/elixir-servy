defmodule Servy.ServicesSupervisor do
  use Supervisor

  def start_link(_arg) do
    IO.puts("Starting the services supervisor...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.PledgeServer,
      {Servy.SensorServer, %{refresh_interval: :timer.minutes(60)}},
      Servy.FourOhFourCounter
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
