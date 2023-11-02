defmodule ObanExample.JobMachine do
  use GenServer

  require Logger

  alias ObanExample.Workers.BusinessTime

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    schedule_work()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:enqueue_job, state) do
    "✨ I'm enqueued! ✨"
    |> Logger.info()

    %{action: "insert 🍕"}
    |> BusinessTime.new()
    |> Oban.insert()
    |> inspect()
    |> Logger.info()


    schedule_work()
    {:noreply, state}
  end

  def schedule_work do
    Process.send_after(self(), :enqueue_job, 10_000)
  end
end
