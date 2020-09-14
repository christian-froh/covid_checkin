defmodule CovidCheckinWeb.EventLive.ShowAttendees do
  use CovidCheckinWeb, :live_view

  alias CovidCheckin.Attendees
  alias CovidCheckin.Events

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "attendee_id" => attendee_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Teilnehmer bearbeiten")
     |> assign(:event, Events.get_event!(id))
     |> assign(:attendee, Attendees.get_attendee!(attendee_id))}
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Alle Teilnehmer")
     |> assign(:event, Events.get_event!(id))}
  end
end
