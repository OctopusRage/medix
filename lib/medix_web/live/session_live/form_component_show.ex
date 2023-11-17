defmodule MedixWeb.SessionLive.FormComponentShow do
  use MedixWeb, :live_component

  alias Medix.GroupSession

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage queue records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="queue-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:customer_identity]} type="text" label="Customer Identity" />
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        <.input field={@form[:session_id]} value={@session.id} type="hidden" />

        <:actions>
          <.button phx-disable-with="Saving...">Add Queue</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{action: :add_queue, queue: queue} = assigns, socket) do
    changeset = GroupSession.change_queue(queue)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"queue" => queue_params}, socket) do
    changeset =
      socket.assigns.queue
      |> GroupSession.change_queue(queue_params)
      |> Map.put(:action, :validate)


    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"queue" => queue_params}, socket) do
    save_queue(socket, socket.assigns.action, queue_params)
  end

  defp save_queue(socket, :edit, queue_params) do
    case GroupSession.update_queue(socket.assigns.queue, queue_params) do
      {:ok, queue} ->
        notify_parent({:saved, queue})
        IO.inspect(socket.assigns.patch)
        session = socket.assigns.session
        {:noreply,
         socket
         |> put_flash(:info, "Queue has been added")
         |> push_patch(to: "/sessions/#{session.queue_group_id}/show/#{session.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_queue(socket, :add_queue, queue_params) do
    case GroupSession.add_queue(socket.assigns.session, queue_params) do
      {:ok, queue} ->
        notify_parent({:saved, queue})
        IO.inspect(socket.assigns.patch)
        session = socket.assigns.session
        {:noreply,
         socket
         |> put_flash(:info, "Session created successfully")
         |> push_patch(to: "/sessions/#{session.queue_group_id}/show/#{session.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
