defmodule Medix.GroupsTest do
  use Medix.DataCase

  alias Medix.Groups

  describe "queue_groups" do
    alias Medix.Groups.QueueGroup

    import Medix.GroupsFixtures

    @invalid_attrs %{descriptions: nil, name: nil}

    test "list_queue_groups/0 returns all queue_groups" do
      queue_group = queue_group_fixture()
      assert Groups.list_queue_groups() == [queue_group]
    end

    test "get_queue_group!/1 returns the queue_group with given id" do
      queue_group = queue_group_fixture()
      assert Groups.get_queue_group!(queue_group.id) == queue_group
    end

    test "create_queue_group/1 with valid data creates a queue_group" do
      valid_attrs = %{descriptions: "some descriptions", name: "some name"}

      assert {:ok, %QueueGroup{} = queue_group} = Groups.create_queue_group(valid_attrs)
      assert queue_group.descriptions == "some descriptions"
      assert queue_group.name == "some name"
    end

    test "create_queue_group/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Groups.create_queue_group(@invalid_attrs)
    end

    test "update_queue_group/2 with valid data updates the queue_group" do
      queue_group = queue_group_fixture()
      update_attrs = %{descriptions: "some updated descriptions", name: "some updated name"}

      assert {:ok, %QueueGroup{} = queue_group} = Groups.update_queue_group(queue_group, update_attrs)
      assert queue_group.descriptions == "some updated descriptions"
      assert queue_group.name == "some updated name"
    end

    test "update_queue_group/2 with invalid data returns error changeset" do
      queue_group = queue_group_fixture()
      assert {:error, %Ecto.Changeset{}} = Groups.update_queue_group(queue_group, @invalid_attrs)
      assert queue_group == Groups.get_queue_group!(queue_group.id)
    end

    test "delete_queue_group/1 deletes the queue_group" do
      queue_group = queue_group_fixture()
      assert {:ok, %QueueGroup{}} = Groups.delete_queue_group(queue_group)
      assert_raise Ecto.NoResultsError, fn -> Groups.get_queue_group!(queue_group.id) end
    end

    test "change_queue_group/1 returns a queue_group changeset" do
      queue_group = queue_group_fixture()
      assert %Ecto.Changeset{} = Groups.change_queue_group(queue_group)
    end
  end
end
