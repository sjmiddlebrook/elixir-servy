defmodule Servy.Bear do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :name, :type, :hibernating]}

  schema "bears" do
    field(:name, :string)
    field(:type, :string)
    field(:hibernating, :boolean, default: false)
  end

  def changeset(bear, attrs) do
    bear
    |> cast(attrs, [:id, :name, :type, :hibernating])
    |> validate_required([:name, :type])

    # Add other validations as necessary
  end

  def is_hibernating(bear) do
    bear.hibernating
  end

  def is_grizzly(bear) do
    bear.type == "Grizzly"
  end
end
