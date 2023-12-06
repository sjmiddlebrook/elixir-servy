defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer
  alias Servy.HttpClient

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4040])

    response = Req.get!("http://localhost:4040/wildthings")

    assert response.status == 200
    assert response.body == "Bears, Lions, Tigers"
  end

  test "accepts a request on a socket and sends back a response concurrently" do
    spawn(HttpServer, :start, [4040])
    parent = self()
    max_concurrent_requests = 5

    for _ <- 1..max_concurrent_requests do
      spawn(fn ->
        response = Req.get!("http://localhost:4040/wildthings")
        send(parent, {:ok, response})
      end)
    end

    for _ <- 1..max_concurrent_requests do
      receive do
        {:ok, response} ->
          assert response.status == 200
          assert response.body == "Bears, Lions, Tigers"
      end
    end
  end
end
