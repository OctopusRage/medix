defmodule MedixWeb.QueueGroupLiveTest do
  use MedixWeb.ConnCase

  import Phoenix.LiveViewTest
  import Medix.GroupsFixtures

  @create_attrs %{descriptions: "some descriptions", name: "some name"}
  @update_attrs %{descriptions: "some updated descriptions", name: "some updated name"}
  @invalid_attrs %{descriptions: nil, name: nil}

  defp create_queue_group(_) do
    queue_group = queue_group_fixture()
    %{queue_group: queue_group}
  end

  describe "Index" do
    setup [:create_queue_group]

    test "lists all queue_groups", %{conn: conn, queue_group: queue_group} do
      {:ok, _index_live, html} = live(conn, ~p"/queue_groups")

      assert html =~ "Listing Queue groups"
      assert html =~ queue_group.descriptions
    end

    test "saves new queue_group", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/queue_groups")

      assert index_live |> element("a", "New Queue group") |> render_click() =~
               "New Queue group"

      assert_patch(index_live, ~p"/queue_groups/new")

      assert index_live
             |> form("#queue_group-form", queue_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#queue_group-form", queue_group: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/queue_groups")

      html = render(index_live)
      assert html =~ "Queue group created successfully"
      assert html =~ "some descriptions"
    end

    test "updates queue_group in listing", %{conn: conn, queue_group: queue_group} do
      {:ok, index_live, _html} = live(conn, ~p"/queue_groups")

      assert index_live |> element("#queue_groups-#{queue_group.id} a", "Edit") |> render_click() =~
               "Edit Queue group"

      assert_patch(index_live, ~p"/queue_groups/#{queue_group}/edit")

      assert index_live
             |> form("#queue_group-form", queue_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#queue_group-form", queue_group: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/queue_groups")

      html = render(index_live)
      assert html =~ "Queue group updated successfully"
      assert html =~ "some updated descriptions"
    end

    test "deletes queue_group in listing", %{conn: conn, queue_group: queue_group} do
      {:ok, index_live, _html} = live(conn, ~p"/queue_groups")

      assert index_live |> element("#queue_groups-#{queue_group.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#queue_groups-#{queue_group.id}")
    end
  end

  describe "Show" do
    setup [:create_queue_group]

    test "displays queue_group", %{conn: conn, queue_group: queue_group} do
      {:ok, _show_live, html} = live(conn, ~p"/queue_groups/#{queue_group}")

      assert html =~ "Show Queue group"
      assert html =~ queue_group.descriptions
    end

    test "updates queue_group within modal", %{conn: conn, queue_group: queue_group} do
      {:ok, show_live, _html} = live(conn, ~p"/queue_groups/#{queue_group}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Queue group"

      assert_patch(show_live, ~p"/queue_groups/#{queue_group}/show/edit")

      assert show_live
             |> form("#queue_group-form", queue_group: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#queue_group-form", queue_group: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/queue_groups/#{queue_group}")

      html = render(show_live)
      assert html =~ "Queue group updated successfully"
      assert html =~ "some updated descriptions"
    end
  end
end
