defmodule SlackWebhook do
  use HTTPoison.Base

  @request_body %{
    icon_emoji: ":fountain:",
    username: "Elixir Fountain Bot"
  }
  @headers %{
    "Content-Type" => "application/json",
    "Accept" => "application/json"
  }

  defp process_url(url) do
    "https://hooks.slack.com/services" <> url
  end

  defp process_request_body(body) do
    @request_body
    |> Map.merge(body)
    |> Poison.encode!
  end

  defp process_request_headers(headers) do
     headers = Map.new(headers)
     @headers
     |> Map.merge(headers)
     |> Enum.into([])
  end
end
