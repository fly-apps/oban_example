defmodule ObanExample.JobMachine do
  use GenServer

  require Logger

  alias ObanExample.Workers.BusinessTime

  @topic "jobs"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def schedule_job do
    Logger.info("✨ Enqueued from #{Fly.my_region()}! ✨")

    %{from: Fly.my_region()}
    |> BusinessTime.new(schedule_in: 10)
    |> Oban.insert()
    |> broadcast(:job_enqueued)
    |> inspect()
    |> Logger.info()
  end


  def broadcast({:error, _reason} = error, _job), do: error
  def broadcast({:ok, job}, event) do
    Phoenix.PubSub.broadcast(ObanExample.PubSub, @topic, {event, job})
    {:ok, job}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(ObanExample.PubSub, @topic)
  end

  # Callbacks

  @impl true
  def init(_opts) do
    schedule_work()
    {:ok, %{}}
  end

  @impl true
  def handle_info(:enqueue_job, state) do
    schedule_job()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :enqueue_job, 10_000)
  end
end
