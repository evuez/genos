defmodule Worker.Poller do
  alias Worker.Router

  def poll(router) do
    poll(router, 0)
  end

  defp poll(router, offset) do
    {:ok, updates} = Nadia.get_updates offset: offset, limit: 20

    updates |> Enum.each(&Router.route(router, &1))

    :timer.sleep 1000

    case List.last(updates) do
      nil    -> poll(router)
      update -> poll(router, update.update_id + 1)
    end
  end
end
