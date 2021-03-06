defmodule CovidCheckinWeb.AttendeeLive.Show do
  use CovidCheckinWeb, :live_view

  alias CovidCheckin.Attendees
  alias CovidCheckin.Events.Attendee
  alias CovidCheckin.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    attendee = Attendees.get_attendee!(id)
    changeset = Attendee.register_changeset(attendee, %{})

    {:noreply,
     socket
     |> assign(:page_title, "Attendee Show")
     |> assign(:attendee, attendee)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"attendee" => attendee_params}, socket) do
    changeset =
      socket.assigns.attendee
      |> Attendee.register_changeset(attendee_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"attendee" => attendee_params}, socket) do
    case Attendees.register_attendee(socket.assigns.attendee, attendee_params) do
      {:ok, _attendee} ->
        {:noreply,
         socket
         |> put_flash(:info, "Erfolgeich angemeldet! Viel Spaß")
         |> push_redirect(to: Routes.attendee_show_path(socket, :show, socket.assigns.attendee))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("leave", _, socket) do
    Attendees.leave_event(socket.assigns.attendee)

    {:noreply,
     socket
     |> put_flash(
       :info,
       "Vielen Dank, dass Sie unsere veranstaltung besucht haben. Wir hoffen Sie hatten viel Spaß!"
     )
     |> push_redirect(to: Routes.attendee_show_path(socket, :show, socket.assigns.attendee))}
  end
end
