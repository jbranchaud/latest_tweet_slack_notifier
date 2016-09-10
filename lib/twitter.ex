defmodule Twitter do
  use HTTPoison.Base

  defp process_url(url) do
    "https://mobile.twitter.com/" <> url
  end

  defp process_response_body(body) do
    tweets =
      body
      |> Floki.find("table.tweet")
      |> Enum.map(fn(tweet_html) ->
        %{
          url: Floki.attribute(tweet_html, "href"),
          content: Floki.find(tweet_html, "tr.tweet-container") |> Floki.text
        }
      end)
    IO.puts("### tweets -> #{Enum.count(tweets)}")
    tweets
  end
end
