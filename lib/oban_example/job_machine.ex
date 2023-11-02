defmodule ObanExample.JobMachine do
  use GenServer

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
    ObanExample.Business.schedule_event_from(Fly.RPC.my_region())

    schedule_work()
    {:noreply, state}
  end

  def schedule_work do
    Process.send_after(self(), :enqueue_job, 60_000)
  end
end
