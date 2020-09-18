defmodule CovidCheckinWeb.EventLive.ShowQr do
  use CovidCheckinWeb, :live_view

  alias CovidCheckin.Attendees

  @impl true
  def mount(%{"id" => event_id}, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Show all QR codes")
      |> assign(:event_id, event_id)
      |> assign(page: 1, per_page: 50, fullly_loaded: false)
      |> load_attendees(event_id)

    socket =
      case length(socket.assigns.attendees) < socket.assigns.per_page do
        true ->
          socket
          |> update(:fullly_loaded, fn _ -> true end)

        _ ->
          socket
      end

    {:ok, socket, temporary_assigns: [attendees: []]}
  end

  @impl true
  def handle_event("load-more", _, socket) do
    socket =
      socket
      |> update(:page, &(&1 + 1))
      |> load_attendees(socket.assigns.event_id)

    socket =
      case length(socket.assigns.attendees) < socket.assigns.per_page do
        true ->
          socket
          |> update(:fullly_loaded, fn _ -> true end)

        _ ->
          socket
      end

    {:noreply, socket}
  end

  defp load_attendees(socket, event_id) do
    assign(socket,
      attendees:
        Attendees.list(event_id, %{page: socket.assigns.page, per_page: socket.assigns.per_page})
    )
  end
end
