defmodule CovidCheckinWeb.EventLive.AttendeeFormComponent do
  use CovidCheckinWeb, :live_component

  alias CovidCheckin.Attendees
  alias CovidCheckin.Events.Attendee

  @impl true
  def update(%{attendee: attendee} = assigns, socket) do
    changeset = Attendee.update_changeset(attendee, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"attendee" => attendee_params}, socket) do
    changeset =
      socket.assigns.attendee
      |> Attendee.update_changeset(attendee_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"attendee" => attendee_params}, socket) do
    case Attendees.update_attendee(socket.assigns.attendee, attendee_params) do
      {:ok, _attendee} ->
        {:noreply,
         socket
         |> put_flash(:info, "Attendee updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
