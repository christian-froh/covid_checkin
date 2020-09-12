defmodule CovidCheckinWeb.EventLive.ShowQr do
  use CovidCheckinWeb, :live_view

  alias CovidCheckin.Events

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, "Show all QR codes")
     |> assign(:event, Events.get_event!(id))}
  end
end