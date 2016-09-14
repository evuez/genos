defmodule Calendar.Schedule do
  use Bridges.Trello

  @list_id Application.get_env(:calendar, :trello_list)
  @checklist "Schedule"

  def create(hours) do
    checklist = @list_id
      |> Trello.grab_card(week_number)
      |> Trello.grab_checklist(@checklist)

    hours
      |> split_days
      |> Enum.each(&Trello.create_item(checklist, &1))

    :ok
  end

  defp split_days(hours), do: String.split(hours, "\n")

  defp week_number do
    {year, week} = :calendar.iso_week_number
    "#{year}-#{week}"
  end
end
