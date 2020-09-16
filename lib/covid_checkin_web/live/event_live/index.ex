defmodule CovidCheckinWeb.EventLive.Index do
  use CovidCheckinWeb, :live_view

  alias CovidCheckin.Events
  alias CovidCheckin.Events.Event

  @impl true
  def mount(_params, _session, socket) do
    loading =
      if socket.connected? do
        false
      else
        true
      end

    access =
      case get_connect_params(socket)["access"] do
        "true" -> true
        _ -> false
      end

    socket =
      assign(socket,
        loading: loading,
        access: access,
        events: list_events()
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Event bearbeiten")
    |> assign(:event, Events.get_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Event erstellen")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Deine Eventübersicht")
    |> assign(:event, nil)
  end

  @impl true
  def handle_event("enter-password", %{"password" => password}, socket) do
    access =
      if password == "123123123" do
        true
      else
        false
      end

    send(self(), {:assign_access_to_socket, access})

    {:noreply, push_event(socket, "store_access", %{access: access})}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    event = Events.get_event!(id)
    {:ok, _} = Events.delete_event(event)

    {:noreply, assign(socket, :events, list_events())}
  end

  @impl true
  def handle_info({:assign_access_to_socket, access}, socket) do
    {:noreply, assign(socket, :access, access)}
  end

  defp list_events do
    Events.list_events()
  end
end
