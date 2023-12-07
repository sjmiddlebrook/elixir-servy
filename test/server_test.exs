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
    spawn(HttpServer, :start, [4041])
    parent = self()
    max_concurrent_requests = 5

    results =
      ["/wildthings", "/bears", "/bears/new", "/bears/1", "/bears/2"]
      |> Enum.map(fn path ->
        url = "http://localhost:4041#{path}"
        Task.async(Req, :get, [url])
      end)
      |> Enum.map(&Task.await(&1))
      |> Enum.each(fn {:ok, response} ->
        assert response.status == 200
      end)
  end
end
