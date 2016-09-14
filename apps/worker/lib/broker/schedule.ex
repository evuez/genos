defmodule Broker.Schedule do
  @behaviour Worker.Broker

  def handle(message) do
    case String.trim(message) do
      ""     -> {:partial, "I'm waiting for your schedule :)"}
      hours  -> schedule(hours)
    end
  end

  defp schedule(hours) do
    case Schedule.create(hours) do
      :ok -> {:ok, "Your schedule has been saved!"}
      _   -> {:error, "Please try again later."}
    end
  end
end
