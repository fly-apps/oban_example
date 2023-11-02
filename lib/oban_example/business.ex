defmodule ObanExample.Business do
  use Oban.Worker, queue: :events

  require Logger

  alias ObanExample.EventFeed

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    args |> inspect() |> Logger.info()
    case args do
      %{"action" => "insert", "inserted_from" => region} ->
        ObanExample.Repo.Local.transaction(fn ->
          event = EventFeed.create_event(%{inserted_from: region})

          %{id: event.id, action: "delete"}
          |> new(schedule_in: 60)
          |> Oban.insert()
        end)

      %{"action" => "delete", "id" => id} ->
        id
        |> EventFeed.get_event!()
        |> EventFeed.delete_event()
    end

    :ok
  end

  def schedule_event_from(region) do
    %{action: "insert", inserted_from: region}
    |> new()
    |> Oban.insert()
  end
end
