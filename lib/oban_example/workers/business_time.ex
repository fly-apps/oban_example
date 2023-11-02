defmodule ObanExample.Workers.BusinessTime do
  use Oban.Worker

  require Logger

  @impl Oban.Worker
  def perform(args) do
    Logger.info("processing the jerb")
    args |> inspect() |> Logger.info()
    :ok
  end
end
