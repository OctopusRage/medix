defmodule MedixWeb.SessionLive.Show do
  use MedixWeb, :live_view

  alias Medix.GroupSession

  @impl true
  def mount(%{"group_id" => group_id, "id" => id}, _session, socket) do
    queues = GroupSession.show_queues(id)
    have_active_session = GroupSession.have_active_queue?(group_id)

    socket =
      socket
      |> assign(:group_id, group_id)
      |> assign(:queues, queues)
      |> assign(:have_active_session, have_active_session)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  def apply_action(
        socket,
        :show,
        %{"group_id" => group_id, "id" => id} = _params
      ) do
    queues = GroupSession.show_queues(id)
    session = GroupSession.get_session!(id)

    socket
    |> push_event("lapsed-time", %{id: "countdown", start_time: session.started_at, finished_time: session.resolved_at})
    |> assign(:queues, queues)
    |> assign(:group_id, group_id)
    |> assign(:page_title, page_title(socket.assigns.live_action))
    |> assign(:session, session)
  end

  def apply_action(
        socket,
        :mark_as_done,
        %{"id" => id, "group_id" => group_id} = _params
      ) do
    case GroupSession.mark_as_done(socket.assigns.session) do
      {:ok, _session} ->
        socket
        |> put_flash(:info, "mark as done")
        |> push_patch(to: "/sessions/#{group_id}/show/#{id}", replace: true)
      {:error, _changeset} ->
        socket
          |> put_flash(:error, "Something went wrong")
          |> push_patch(to: "/sessions/#{group_id}/show/#{id}", replace: true)
    end
  end

  def apply_action(
        socket,
        :start_session,
        %{"id" => id, "group_id" => group_id} = _params
      ) do
    case GroupSession.start_session(socket.assigns.session) do
      {:ok, session} ->
        socket
        |> assign(:session, session)
        |> put_flash(:info, "mark as done")
        |> push_patch(to: "/sessions/#{group_id}/show/#{id}", replace: true)
      {:error, _changeset} ->
        socket
          |> put_flash(:error, "Something went wrong")
          |> push_patch(to: "/sessions/#{group_id}/show/#{id}", replace: true)
    end
  end

  defp page_title(:show), do: "Show Session"
  defp page_title(:edit), do: "Edit Session"
  defp page_title(:mark_as_done), do: "Show Session"
end
