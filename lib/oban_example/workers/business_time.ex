defmodule ObanExample.Workers.BusinessTime do
  use Oban.Worker

  require Logger

  alias ObanExample.JobMachine

  @impl Oban.Worker
  def perform(args) do
    Logger.info("processing the job")
    args |> inspect() |> Logger.info()

    JobMachine.broadcast({:ok, args}, :job_processed)

    :ok
  end
end
