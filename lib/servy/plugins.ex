require Logger

defmodule Servy.Plugins do
  alias Servy.Conv

  @doc """
  This function is called when the request is not found.
  """
  def track(%Conv{status: 404, path: path} = conv) do
    Logger.warning("!! Warning: #{path}")
    conv
  end

  def track(%Conv{} = conv), do: conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{conv | path: "/wildthings"}
  end

  def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv) do
    %{conv | path: "/bears/#{id}"}
  end

  def rewrite_path(%Conv{} = conv), do: conv

  def log(%Conv{} = conv), do: IO.inspect(conv)
end
