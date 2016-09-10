defmodule LatestTweetSlackNotifier do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(LatestTweetSlackNotifier.Notifier, [])
    ]

    opts = [strategy: :one_for_one, name: LatestTweetSlackNotifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
