defmodule Broker.Calendar do
  @behaviour Worker.Broker

  def handle(_), do: {:ok, "Schedule saved!"}
end
