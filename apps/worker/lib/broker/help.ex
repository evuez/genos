defmodule Broker.Help do
  @behaviour Worker.Broker

  def handle(_), do: {:ok, "Available commands are /sh /ex /sc /h"}
end
