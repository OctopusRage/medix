defmodule MedixWeb.SessionLive.Show do
  use MedixWeb, :live_view

  alias Medix.GroupSession
  import MedixWeb.SessionLive.TableComponent

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    session = GroupSession.get_session!(id)
    queues = GroupSession.list_queues(id)
    have_active_session = GroupSession.have_active_queue?(session.queue_group_id)

    socket =
      socket
      |> assign(:group_id, session.queue_group_id)
      |> assign(:queue, %{})
      |> assign(:queues, queues)
      |> stream(:queues, queues)
      |> assign(:have_active_session, have_active_session)

    {:ok, socket}
  end

  def mount(_params, _session, socket) do
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
    queues = GroupSession.list_queues(id)
    session = GroupSession.get_session!(id)

    socket
    |> push_event("lapsed-time", %{
      id: "countdown",
      start_time: session.started_at,
      finished_time: session.resolved_at
    })
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
        :start,
        %{"id" => id, "group_id" => group_id} = _params
      ) do
    case GroupSession.start_session(socket.assigns.session) do
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

  def apply_action(
        socket,
        :add_queue,
        %{"id" => id}
      ) do
    session = GroupSession.get_session!(id)
    queues = GroupSession.list_queues(id)

    socket
    |> assign(:group_id, session.queue_group_id)
    |> assign(:queues, queues)
    |> assign(:session, session)
    |> assign(:page_title, "Add Queue")
  end

  def apply_action(
        socket,
        :next_queue,
        %{"id" => id}
      ) do
    session = GroupSession.get_session!(id)
    socket = case GroupSession.next_queue(session) do
      {:ok, _} -> socket |> put_flash(:info, "Change into next queue")
      {:error, err} -> socket |> put_flash(:error, err)
    end
    queues = GroupSession.list_queues(id)

    socket
    |> assign(:group_id, session.queue_group_id)
    |> assign(:queues, queues)
    |> assign(:session, session)
    |> push_patch(to: "/sessions/#{session.queue_group_id}/show/#{id}")
  end

  def apply_action(
        socket,
        :prev_queue,
        %{"id" => id}
      ) do
    session = GroupSession.get_session!(id)
    socket = case GroupSession.prev_queue(session) do
      {:ok, _} -> socket |> put_flash(:info, "Change into previous queue")
      {:error, err} -> socket |> put_flash(:error, err)
    end
    queues = GroupSession.list_queues(id)

    socket
    |> assign(:group_id, session.queue_group_id)
    |> assign(:queues, queues)
    |> assign(:session, session)
    |> push_patch(to: "/sessions/#{session.queue_group_id}/show/#{id}")
  end


  @impl true
  def handle_info({MedixWeb.SessionLive.FormComponentShow, {:saved, queue}}, socket) do
    {:noreply, stream_insert(socket, :queues, queue)}
  end


  defp page_title(:show), do: "Show Session"
  defp page_title(:edit), do: "Edit Session"
  defp page_title(:mark_as_done), do: "Show Session"
  defp page_title(:add_queue), do: "Show Session"


end
