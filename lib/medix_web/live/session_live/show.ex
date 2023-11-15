defmodule MedixWeb.SessionLive.Show do
  use MedixWeb, :live_view

  alias Medix.GroupSession

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "group_id" => group_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:group_id, group_id)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:session, GroupSession.get_session!(id))}
  end

  defp page_title(:show), do: "Show Session"
  defp page_title(:edit), do: "Edit Session"
end
