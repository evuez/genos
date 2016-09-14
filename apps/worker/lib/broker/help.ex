defmodule Broker.Help do
  @behaviour Worker.Broker

  def handle(_), do: {:ok, "Available commands are /sc /ex /sc /h"}
end
