defmodule Broker.Shopping do
  @behaviour Worker.Broker

  def handle(message) do
    case String.trim(message) do
      ""    -> {:partial, "I'm waiting for your items :)"}
      items -> add(items)
    end
  end

  def add(items) do
    case Shopping.Item.create(items) do
      :ok -> {:ok, "This has been added to your shopping list!"}
      _   -> {:error, "Please try again later."}
    end
  end
end
