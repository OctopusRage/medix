defmodule MedixWeb.QueueGroupLive.FormComponent do
  use MedixWeb, :live_component

  alias Medix.Groups

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage queue_group records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="queue_group-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:descriptions]} type="textarea" label="Descriptions" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Queue group</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{queue_group: queue_group} = assigns, socket) do
    changeset = Groups.change_queue_group(queue_group)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"queue_group" => queue_group_params}, socket) do
    changeset =
      socket.assigns.queue_group
      |> Groups.change_queue_group(queue_group_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"queue_group" => queue_group_params}, socket) do
    save_queue_group(socket, socket.assigns.action, queue_group_params)
  end

  defp save_queue_group(socket, :edit, queue_group_params) do
    case Groups.update_queue_group(socket.assigns.queue_group, queue_group_params) do
      {:ok, queue_group} ->
        notify_parent({:saved, queue_group})

        {:noreply,
         socket
         |> put_flash(:info, "Queue group updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_queue_group(socket, :new, queue_group_params) do
    case Groups.create_queue_group(queue_group_params) do
      {:ok, queue_group} ->
        notify_parent({:saved, queue_group})

        {:noreply,
         socket
         |> put_flash(:info, "Queue group created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
