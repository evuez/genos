defmodule Worker.Router do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  def route(router, update) do
    GenServer.cast(router, {:route, update})
  end

  # Callbacks

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_cast({:route, %{message: %{chat: chat, text: text}}}, threads) do
    threads = Map.update(threads, chat.id, [text], &(&1 ++ [text]))

    {:ok, threads} = Map.get(threads, chat.id)
      |> map
      |> deliver
      |> reply(chat)
      |> clean(threads, chat)

    {:noreply, threads}
  end

  defp map(thread) do
    case Enum.join(thread, "\n") do
      "/c" <> m -> {Broker.Calendar, m}
      "/e" <> m -> {Broker.Expenses, m}
      "/s" <> m -> {Broker.Shopping, m}
      "/h" <> m -> {Broker.Help, m}
      garbage   -> {Broker.Garbage, garbage}
    end
  end

  defp deliver({broker, message}) do
    broker.handle(message)
  end

  defp reply({status, message}, chat) do
    {:ok, _} = Nadia.send_message(chat.id, message)
    status
  end

  defp clean(:partial, threads, chat), do: {:ok, threads}
  defp clean(_status,  threads, chat), do: {:ok, Map.delete(threads, chat.id)}
end
