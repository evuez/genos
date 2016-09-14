defmodule Shopping.Item do
  use Bridges.Trello
  alias Shopping.List

  def create(body) do
    list = List.grab

    split_items(body)
      |> Enum.each(&Trello.create_item(list, &1))

    :ok
  end

  defp split_items(items), do: String.split(items, "\n")
end
