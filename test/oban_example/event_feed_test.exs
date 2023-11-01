defmodule ObanExample.EventFeedTest do
  use ObanExample.DataCase

  alias ObanExample.EventFeed

  describe "events" do
    alias ObanExample.EventFeed.Event

    import ObanExample.EventFeedFixtures

    @invalid_attrs %{inserted_from: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert EventFeed.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert EventFeed.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{inserted_from: "some inserted_from"}

      assert {:ok, %Event{} = event} = EventFeed.create_event(valid_attrs)
      assert event.inserted_from == "some inserted_from"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EventFeed.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{inserted_from: "some updated inserted_from"}

      assert {:ok, %Event{} = event} = EventFeed.update_event(event, update_attrs)
      assert event.inserted_from == "some updated inserted_from"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = EventFeed.update_event(event, @invalid_attrs)
      assert event == EventFeed.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = EventFeed.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> EventFeed.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = EventFeed.change_event(event)
    end
  end
end
