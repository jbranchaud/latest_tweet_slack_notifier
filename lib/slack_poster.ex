defmodule SlackPoster do
  def post(message) do
    SlackWebhook.post!(webhook_url, %{text: message})
  end

  defp webhook_url do
    [
      :slack_key_part_1,
      :slack_key_part_2,
      :slack_key_part_3
    ]
    |> Enum.map(fn(key) ->
      Application.get_env(:latest_tweet_slack_notifier, key)
    end)
    |> Enum.join("/")
    |> (&("/" <> &1)).()
  end
end
