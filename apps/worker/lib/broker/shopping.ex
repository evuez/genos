defmodule Broker.Shopping do
  @behaviour Worker.Broker

  def handle(message) do
    case String.strip(message) do
      "" -> {:partial, "I'm waiting for your items :)"}
      _  -> {:ok, "This has been added to your shopping list!"}
    end
  end
end
