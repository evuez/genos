defmodule Bridges.Trello do
  @api_root "https://api.trello.com/1/"
  @api_key Application.get_env(:bridges, :trello_key)
  @api_token Application.get_env(:bridges, :trello_token)

  defmacro __using__(_) do
    quote do
      alias Bridges.Trello
    end
  end


  # API
  # Cards

  def grab_card(list_id, name) do
    case get_card(list_id, name) do
      {:ok, card_id} -> %{"id" => card_id}
      {:error, _}    -> create_card(list_id, name)
    end
  end

  def get_card(list_id, name) do
    cards = get!("lists/#{list_id}/cards")
      |> Enum.filter(fn %{"name" => n} -> n == name end)

    case cards do
      [%{"id" => id}|_] -> {:ok, id}
      []                -> {:error, "Not found"}
    end
  end

  def create_card(list_id, name) do
    "lists/#{list_id}/cards"
      |> post!(%{name: name, due: nil})
  end


  # API
  # Checklists

  def grab_checklist(%{"id" => card_id}, name), do: grab_checklist(card_id, name)

  def grab_checklist(card_id, name) do
    case get_checklist(card_id, name) do
      {:ok, checklist_id} -> %{"id" => checklist_id, "idCard" => card_id}
      {:error, _}         -> create_checklist(card_id, name)
    end
  end

  def get_checklist(card_id, name) do
    checklists = get!("cards/#{card_id}/checklists")
      |> Enum.filter(fn %{"name" => n} -> n == name end)

    case checklists do
      [%{"id" => id}|_] -> {:ok, id}
      []                -> {:error, "Not found"}
    end
  end

  def create_checklist(card_id, name) do
    "cards/#{card_id}/checklists"
      |> post!(%{name: name})
  end


  # API
  # Items

  def create_item(%{"id" => checklist_id, "idCard" => card_id}, body), do: create_item(card_id, checklist_id, body)

  def create_item(card_id, checklist_id, body) do
    "cards/#{card_id}/checklist/#{checklist_id}/checkItem"
      |> post!(%{name: body})
  end


  # Helpers

  defp create_url(route) do
    "#{@api_root}#{route}?key=#{@api_key}&token=#{@api_token}"
  end

  defp create_params(route, body) do
    {create_url(route), Poison.encode!(body), %{"Content-type" => "application/json"}}
  end

  defp post!(route, body) do
    {url, body, headers} = create_params route, body
    HTTPoison.post!(url, body, headers)
      |> unwrap_body
      |> Poison.decode!
  end

  defp get!(route) do
    create_url(route)
      |> HTTPoison.get!
      |> unwrap_body
      |> Poison.decode!
  end

  defp unwrap_body(%{body: body, status_code: 200}), do: body
end
