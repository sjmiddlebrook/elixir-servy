defmodule Servy.Wildthings do
  alias Servy.Bear

  @db_path Path.expand("db", File.cwd!())

  def list_bears do
    @db_path
    |> Path.join("bears.json")
    |> read_json
    |> Jason.decode!()
    |> Map.get("bears")
    |> Enum.map(&create_bear_changeset/1)
  end

  defp read_json(source) do
    case File.read(source) do
      {:ok, contents} ->
        contents
      {:error, reason} ->
        IO.inspect "Error reading #{source}: #{reason}"
        "[]"
    end
  end

  defp create_bear_changeset(bear_data) do
    {:ok, bear} =
      %Bear{}
      |> Bear.changeset(bear_data)
      |> apply_changeset()

    bear
  end

  defp apply_changeset(changeset) do
    case changeset.valid? do
      true -> {:ok, Ecto.Changeset.apply_changes(changeset)}
      false -> {:error, changeset}
    end
  end

  def get_bear(id) when is_integer(id) do
    list_bears()
    |> Enum.find(fn bear -> bear.id == id end)
  end

  def get_bear(id) when is_binary(id) do
    id |> String.to_integer() |> get_bear()
  end

  def get_bear(_id) do
    raise ArgumentError, "id must be an integer or a string"
  end
end
