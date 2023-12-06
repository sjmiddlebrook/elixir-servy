defmodule Servy.UserApi do
  def query(id) do
    id
    |> generate_api_url()
    |> Req.get()
    |> handle_response()
  end

  defp generate_api_url(id) do
    "https://jsonplaceholder.typicode.com/users/#{id}"
  end

  defp handle_response({:ok, %{status: 200, body: body}}) do
    city =
      body
      |> get_in(["address", "city"])

    {:ok, city}
  end

  defp handle_response({:ok, %{status: status}}) do
    message = "Unexpected status code: #{status}"
    {:error, message}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end
end
