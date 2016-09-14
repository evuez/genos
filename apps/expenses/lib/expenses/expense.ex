defmodule Expenses.Expense do
  use Bridges.IFTTT

  def log(category, amount) do
    IFTTT.trigger "expenses", {date, category, amount}
  end

  defp date do
    {{year, month, day}, _} = :calendar.local_time
    "#{year}-#{month}-#{day}"
  end
end
