defmodule MedixWeb.SessionLive.Index do
  use MedixWeb, :live_view

  alias Medix.GroupSession
  alias Medix.GroupSession.Session
  alias Medix.Groups

  @impl true
  def mount(%{"group_id" => group_id}, _session, socket) do
    group = Groups.get_queue_group!(group_id)
    socket = stream(socket, :sessions, GroupSession.list_sessions(group_id)) |> assign(:group_id, group_id) |> assign(:group, group)
    {:ok, socket}
  end

  def mount(_, _session, socket) do
    {:ok, stream(socket, :sessions, GroupSession.list_sessions())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id, "group_id" => group_id}) do
    socket
    |> assign(:group_id, group_id)
    |> assign(:page_title, "Edit Session")
    |> assign(:session, GroupSession.get_session!(id))
  end

  defp apply_action(socket, :new, %{"group_id" => group_id} = _params) do
    socket
    |> assign(:group_id, group_id)
    |> assign(:page_title, "New Session")
    |> assign(:session, %Session{})
  end

  defp apply_action(socket, :index, %{"group_id" => group_id} = _params) do
    socket
    |> assign(:group_id, group_id)
    |> assign(:page_title, "Listing Sessions")
    |> assign(:session, nil)
  end

  @impl true
  def handle_info({MedixWeb.SessionLive.FormComponent, {:saved, session}}, socket) do
    {:noreply, stream_insert(socket, :sessions, session, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    session = GroupSession.get_session!(id)
    {:ok, _} = GroupSession.delete_session(session)

    {:noreply, stream_delete(socket, :sessions, session)}
  end
end
