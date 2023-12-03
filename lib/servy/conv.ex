defmodule Servy.Conv do
  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            resp_headers: %{
              "Content-Type" => "text/html"
            },
            resp_body: "",
            status: nil

  def full_status(conv) do
    "#{conv.status} #{status_reason(conv.status)}"
  end

  def put_resp_content_type(conv, content_type) do
    new_headers = Map.put(conv.resp_headers, "Content-Type", content_type)
    %{conv | resp_headers: new_headers}
  end

  def put_content_length(conv) do
    new_headers = Map.put(conv.resp_headers, "Content-Length", byte_size(conv.resp_body))
    %{conv | resp_headers: new_headers}
  end

  def format_response_headers(conv) do
    conv.resp_headers
    |> Map.to_list()
    |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.join("\r\n")
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
