defmodule Shopping.Item do
  use Bridges.Trello
  alias Shopping.List

  def create(body) do
    List.grab
      |> Trello.create_item(body)
  end
end
