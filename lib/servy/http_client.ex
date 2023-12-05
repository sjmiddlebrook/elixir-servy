defmodule Servy.HttpClient do
  def send_request(request) do
    {:ok, socket} = :gen_tcp.connect('localhost', 4000, [:binary, active: false])
    :gen_tcp.send(socket, request)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    response
  end
end
