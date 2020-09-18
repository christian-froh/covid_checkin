defmodule CovidCheckinWeb.ModalComponent do
  use CovidCheckinWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="modal is-active"
      phx-target="#<%= @id %>"
      phx-page-loading>

      <div class="modal-background"></div>
      <div class="modal-content">
        <div class="box">
          <%= live_component @socket, @component, @opts %>
        </div>
      </div>
      <%= live_patch raw("&times;"), to: @return_to, class: "modal-close is-large" %>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
