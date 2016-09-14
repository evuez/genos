defmodule Broker.Help do
  @behaviour Worker.Broker

  def handle(_), do: {:ok, "Available commands are /c /e /s /h"}
end
