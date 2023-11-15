defmodule MedixWeb.QueueGroupLive.Index do
  use MedixWeb, :live_view

  alias Medix.Groups
  alias Medix.Groups.QueueGroup

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :queue_groups, Groups.list_queue_groups())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Queue group")
    |> assign(:queue_group, Groups.get_queue_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Queue group")
    |> assign(:queue_group, %QueueGroup{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Queue groups")
    |> assign(:queue_group, nil)
  end

  @impl true
  def handle_info({MedixWeb.QueueGroupLive.FormComponent, {:saved, queue_group}}, socket) do
    {:noreply, stream_insert(socket, :queue_groups, queue_group, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    queue_group = Groups.get_queue_group!(id)
    {:ok, _} = Groups.delete_queue_group(queue_group)

    {:noreply, stream_delete(socket, :queue_groups, queue_group)}
  end
end
