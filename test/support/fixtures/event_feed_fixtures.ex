defmodule ObanExample.EventFeedFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `ObanExample.EventFeed` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        inserted_from: "some inserted_from"
      })
      |> ObanExample.EventFeed.create_event()

    event
  end
end
