defmodule Broker.Expenses do
  @behaviour Worker.Broker

  def handle(message) do
    [category, amount|_] = String.split(message)

    case Expenses.log(category, amount) do
      :ok -> {:ok, "Logged!"}
      _   -> {:error, "Please try again later."}
    end
  end
end
