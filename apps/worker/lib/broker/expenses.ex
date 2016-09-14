defmodule Broker.Expenses do
  @behaviour Worker.Broker

  def handle(_), do: {:ok, "Logged!"}
end
