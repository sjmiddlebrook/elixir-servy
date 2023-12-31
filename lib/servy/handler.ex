defmodule Servy.Handler do
  @moduledoc """
  This module handles the request and response.
  """
  alias Servy.Conv
  alias Servy.BearController

  @pages_path Path.expand("pages", File.cwd!())

  import Servy.Conv, only: [put_content_length: 1, full_status: 1, format_response_headers: 1]
  import Servy.Plugins, only: [track: 1, rewrite_path: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2, handle_markdown_file: 2]
  import Servy.View, only: [render: 3]

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    # |> log
    |> route
    |> track
    |> put_content_length
    |> format_response
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{method: "GET", path: "/bears"} = conv) do
    BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = conv) do
    Servy.Api.BearController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = conv) do
    route_pages(conv, "form.html")
  end

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv) do
    BearController.delete(conv, conv.params)
  end

  def route(%Conv{method: "POST", path: "/bears"} = conv) do
    BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "POST", path: "/api/bears"} = conv) do
    Servy.Api.BearController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    route_pages(conv, "about.html")
  end

  def route(%Conv{method: "GET", path: "/faq"} = conv) do
    route_pages(conv, "faq.md")
  end

  def route(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    time |> String.to_integer() |> :timer.sleep()

    %{conv | status: 200, resp_body: "Awake!"}
  end

  def route(%Conv{method: "GET", path: "/kaboom"} = _conv) do
    raise "Kaboom!"
  end

  def route(%Conv{method: "GET", path: "/sensors"} = conv) do
    sensor_data = Servy.SensorServer.get_sensor_data()

    render(conv, "sensors.eex",
      snapshots: sensor_data.snapshots,
      bigfoot: sensor_data.bigfoot_result
    )
  end

  def route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{method: "GET", path: "/pledges/new"} = conv) do
    Servy.PledgeController.new(conv)
  end

  def route(%Conv{method: "GET", path: "/404s"} = conv) do
    counts = Servy.FourOhFourCounter.get_counts()
    IO.puts(inspect(counts))
    %{conv | status: 200, resp_body: "Test"}
  end

  def route(%Conv{} = conv) do
    %{conv | status: 404, resp_body: "No #{conv.path} here!"}
  end

  def route_pages(%Conv{} = conv, file_name) do
    file_type = Path.extname(file_name)
    route_pages(conv, file_name, file_type)
  end

  def route_pages(%Conv{} = conv, file_name, ".html") do
    @pages_path
    |> Path.join(file_name)
    |> File.read()
    |> handle_file(conv)
  end

  def route_pages(%Conv{} = conv, file_name, ".md") do
    @pages_path
    |> Path.join(file_name)
    |> File.read()
    |> handle_markdown_file(conv)
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{full_status(conv)}\r
    #{format_response_headers(conv)}\r
    \r
    #{conv.resp_body}
    """
  end
end
