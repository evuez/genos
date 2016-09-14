defmodule Broker.Garbage do
  @behaviour Worker.Broker

  def handle(_), do: {:error, "I didn't understand that."}
end
