defmodule MedixWeb.BoardLive.Index do
  use MedixWeb, :live_view

  alias Medix.Queue
  alias Medix.Queue.Board

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, socket}
  end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Board")
  #   |> assign(:board, Queue.get_board!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Board")
  #   |> assign(:board, %Board{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Board")
  #   |> assign(:board, nil)
  # end

  # @impl true
  # def handle_info({MedixWeb.BoardLive.FormComponent, {:saved, board}}, socket) do
  #   {:noreply, stream_insert(socket, :board_collection, board)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   board = Queue.get_board!(id)
  #   {:ok, _} = Queue.delete_board(board)

  #   {:noreply, stream_delete(socket, :board_collection, board)}
  # end
end
