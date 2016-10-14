defmodule Worker.Poller do
  alias Worker.Router

  @whitelist Application.get_env(:worker, :whitelist)

  def start_link(router) do
    Task.start_link(__MODULE__, :poll, [router])
  end

  def poll(router) do
    poll(router, 0)
  end

  defp poll(router, offset) do
    {:ok, updates} = Nadia.get_updates offset: offset, limit: 20

    updates
      |> Enum.filter(&whitelist/1)
      |> Enum.each(&Router.route(router, &1))

    :timer.sleep 1000

    case List.last(updates) do
      nil    -> poll(router)
      update -> poll(router, update.update_id + 1)
    end
  end

  defp whitelist(%{message: %{from: %{username: username}}}) do
    Enum.member?(@whitelist, username)
  end
end
