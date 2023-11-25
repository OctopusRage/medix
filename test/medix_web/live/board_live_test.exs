defmodule MedixWeb.BoardLiveTest do
  use MedixWeb.ConnCase

  import Phoenix.LiveViewTest
  import Medix.QueueFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_board(_) do
    board = board_fixture()
    %{board: board}
  end

  describe "Index" do
    setup [:create_board]

    test "lists all board", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/board")

      assert html =~ "Listing Board"
    end

    test "saves new board", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/board")

      assert index_live |> element("a", "New Board") |> render_click() =~
               "New Board"

      assert_patch(index_live, ~p"/board/new")

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#board-form", board: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/board")

      html = render(index_live)
      assert html =~ "Board created successfully"
    end

    test "updates board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, ~p"/board")

      assert index_live |> element("#board-#{board.id} a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(index_live, ~p"/board/#{board}/edit")

      assert index_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#board-form", board: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/board")

      html = render(index_live)
      assert html =~ "Board updated successfully"
    end

    test "deletes board in listing", %{conn: conn, board: board} do
      {:ok, index_live, _html} = live(conn, ~p"/board")

      assert index_live |> element("#board-#{board.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#board-#{board.id}")
    end
  end

  describe "Show" do
    setup [:create_board]

    test "displays board", %{conn: conn, board: board} do
      {:ok, _show_live, html} = live(conn, ~p"/board/#{board}")

      assert html =~ "Show Board"
    end

    test "updates board within modal", %{conn: conn, board: board} do
      {:ok, show_live, _html} = live(conn, ~p"/board/#{board}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Board"

      assert_patch(show_live, ~p"/board/#{board}/show/edit")

      assert show_live
             |> form("#board-form", board: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#board-form", board: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/board/#{board}")

      html = render(show_live)
      assert html =~ "Board updated successfully"
    end
  end
end
