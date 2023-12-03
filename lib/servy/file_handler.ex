defmodule Servy.FileHandler do
  def handle_file({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def handle_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found!"}
  end

  def handle_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def handle_markdown_file({:ok, content}, conv) do
    html = read_markdown(content)
    %{conv | status: 200, resp_body: html}
  end

  def handle_markdown_file({:error, :enoent}, conv) do
    %{conv | status: 404, resp_body: "File not found!"}
  end

  def handle_markdown_file({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}"}
  end

  def read_markdown(content) do
    markdown_to_html(Earmark.as_html(content))
  end

  def markdown_to_html({:ok, html, _}) do
    html
  end

  def markdown_to_html({:error, html, _}) do
    html
  end
end
