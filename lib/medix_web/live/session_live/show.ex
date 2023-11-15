defmodule MedixWeb.SessionLive.Show do
  use MedixWeb, :live_view

  alias Medix.GroupSession

  @impl true
  def mount(%{"group_id" => group_id, "id" => id}, _session, socket) do
    queues = GroupSession.show_queues(id)
    IO.inspect queues
    socket |> assign(:group_id, group_id) |> assign(:queues, queues)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "group_id" => group_id}, _, socket) do
    queues = GroupSession.show_queues(id)
    {:noreply,
     socket
     |> assign(:queues, queues)
     |> assign(:group_id, group_id)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:session, GroupSession.get_session!(id))}
  end

  defp page_title(:show), do: "Show Session"
  defp page_title(:edit), do: "Edit Session"
end
