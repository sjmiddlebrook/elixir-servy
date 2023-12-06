defmodule Servy.VideoCam do
  def get_snapshot(camera_name) do
    # code for request to external api
    # simulate wait
    :timer.sleep(1000)
    # example response
    "#{camera_name}-snapshot.jpg"
  end
end
