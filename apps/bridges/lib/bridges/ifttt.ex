defmodule Bridges.IFTTT do
  @api_root "https://maker.ifttt.com/trigger/"
  @api_key Application.get_env(:bridges, :ifttt_key)

  defmacro __using__(_) do
    quote do
      alias Bridges.IFTTT
    end
  end

  # API
  # Rows

  def trigger(event, {value1, value2, value3}) do
    post! event, %{value1: value1, value2: value2, value3: value3}
  end

  # Helpers

  defp create_params(event, body) do
    {"#{@api_root}#{event}/with/key/#{@api_key}", Poison.encode!(body), %{"Content-type" => "application/json"}}
  end

  defp post!(event, body) do
    {url, body, headers} = create_params event, body
    HTTPoison.post!(url, body, headers)
      |> unwrap_body
  end

  defp unwrap_body(%{body: body, status_code: 200}), do: body
end
