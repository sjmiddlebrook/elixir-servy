defmodule Servy.Bear do
  @derive {Jason.Encoder, only: [:id, :name, :type, :hibernating]}
  defstruct id: nil,
            name: "",
            type: "",
            hibernating: false

  def is_hibernating(bear) do
    bear.hibernating
  end

  def is_grizzly(bear) do
    bear.type == "Grizzly"
  end
end
