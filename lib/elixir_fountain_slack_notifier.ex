defmodule ElixirFountainSlackNotifier do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ElixirFountainSlackNotifier.Notifier, [])
    ]

    opts = [strategy: :one_for_one, name: ElixirFountainSlackNotifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
