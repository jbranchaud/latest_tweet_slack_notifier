defmodule ElixirFountainSlackNotifier.Notifier do
  use GenServer

  @tweeter Application.get_env(:elixir_fountain_slack_notifier, :tweeter)

  def start_link do
    initial_state = %{
      latest_tweet: get_almost_latest_tweet.url
    }
    GenServer.start_link(__MODULE__, initial_state)
  end

  def init(state) do
    if Mix.env != :test do
      GenServer.cast(self(), :work)
    end
    {:ok, state}
  end

  def handle_cast(:work, state) do
    state = do_work(state)
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), {:"$gen_cast", :work}, 30 * 1000)
  end

  defp do_work(state) do
    IO.puts("You are doing some work")
    case state.latest_tweet |> get_newer_tweets |> post_newer_tweets do
      {:ok, newer_url} -> %{state | latest_tweet: newer_url}
      _ -> state
    end
  end

  defp post_newer_tweets([]) do
    IO.puts("There were no new tweets to post")
    :none
  end
  defp post_newer_tweets([head|_tail] = tweets) do
    IO.puts("There are #{Enum.count(tweets)} new tweets to post")
    tweets
    |> Enum.each(fn(tweet) -> SlackPoster.post(tweet.content) end)
    {:ok, head.url}
  end

  defp get_almost_latest_tweet do
    [_first, second | _tail] = Twitter.get!(@tweeter).body
    second
  end

  defp get_newer_tweets(latest_tweet_url) do
    Twitter.get!(@tweeter).body
    |> Enum.take_while(fn(tweet) -> tweet.url != latest_tweet_url end)
  end
end
