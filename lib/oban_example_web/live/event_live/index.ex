defmodule ObanExampleWeb.EventLive.Index do
  use ObanExampleWeb, :live_view

  alias ObanExample.EventFeed
  alias ObanExample.EventFeed.Event

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_region, ObanExample.current_region())
     |> stream(:events, EventFeed.list_events())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Event")
    |> assign(:event, EventFeed.get_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Events")
    |> assign(:event, nil)
  end

  @impl true
  def handle_info({ObanExampleWeb.EventLive.FormComponent, {:saved, event}}, socket) do
    {:noreply, stream_insert(socket, :events, event)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = EventFeed.get_event!(id)
    {:ok, _} = EventFeed.delete_event(event)

    {:noreply, stream_delete(socket, :events, event)}
  end
end
