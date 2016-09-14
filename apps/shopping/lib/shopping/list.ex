defmodule Shopping.List do
  use Bridges.Trello

  @list_id Application.get_env(:shopping, :trello_list)
  @checklist "List"

  def grab do
    @list_id
      |> Trello.grab_card(week_number)
      |> Trello.grab_checklist(@checklist)
  end

  defp week_number do
    {year, week} = :calendar.iso_week_number
    "#{year}-#{week}"
  end
end
