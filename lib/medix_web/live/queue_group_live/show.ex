defmodule MedixWeb.QueueGroupLive.Show do
  use MedixWeb, :live_view

  alias Medix.Groups

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:queue_group, Groups.get_queue_group!(id))}
  end

  defp page_title(:show), do: "Show Queue group"
  defp page_title(:edit), do: "Edit Queue group"
end
