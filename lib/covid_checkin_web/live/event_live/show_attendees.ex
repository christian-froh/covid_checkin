defmodule CovidCheckinWeb.EventLive.ShowAttendees do
  use CovidCheckinWeb, :live_view

  alias CovidCheckin.Attendees
  alias CovidCheckin.Events

  @impl true
  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        search: ""
      )

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
    event = Events.get_event!(id)

    {:noreply,
     socket
     |> assign(:page_title, "Alle Teilnehmer")
     |> assign(:event, event)
     |> assign(:attendees, event.attendees)
     |> assign(:all_attendees, event.attendees)}
  end

  @impl true
  def handle_event("attendee-search", %{"search" => last_name}, socket) do
    attendees =
      Enum.filter(socket.assigns.all_attendees, fn attendee ->
        attendee.last_name != nil &&
          String.contains?(String.downcase(attendee.last_name), String.downcase(last_name))
      end)

    socket =
      assign(socket,
        search: last_name,
        attendees: attendees
      )

    {:noreply, socket}
  end

  defp highlight_last_name(lastname, ""), do: lastname

  defp highlight_last_name(lastname, search) do
    String.replace(lastname, search, "<span class=\"text_highlight\">#{search}</span>")
  end

  defp to_timezone(nil), do: nil

  defp to_timezone(datetime) do
    datetime = Timex.Timezone.convert(datetime, "Europe/Berlin")
    "#{datetime.day}.#{datetime.month}.#{datetime.year} #{datetime.hour}:#{datetime.minute}"
  end
end
