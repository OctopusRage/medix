defmodule Medix.GroupSessionTest do
  use Medix.DataCase

  alias Medix.GroupSession

  describe "sessions" do
    alias Medix.GroupSession.Session

    import Medix.GroupSessionFixtures

    @invalid_attrs %{name: nil}

    test "list_sessions/0 returns all sessions" do
      session = session_fixture()
      assert GroupSession.list_sessions() == [session]
    end

    test "get_session!/1 returns the session with given id" do
      session = session_fixture()
      assert GroupSession.get_session!(session.id) == session
    end

    test "create_session/1 with valid data creates a session" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Session{} = session} = GroupSession.create_session(valid_attrs)
      assert session.name == "some name"
    end

    test "create_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GroupSession.create_session(@invalid_attrs)
    end

    test "update_session/2 with valid data updates the session" do
      session = session_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Session{} = session} = GroupSession.update_session(session, update_attrs)
      assert session.name == "some updated name"
    end

    test "update_session/2 with invalid data returns error changeset" do
      session = session_fixture()
      assert {:error, %Ecto.Changeset{}} = GroupSession.update_session(session, @invalid_attrs)
      assert session == GroupSession.get_session!(session.id)
    end

    test "delete_session/1 deletes the session" do
      session = session_fixture()
      assert {:ok, %Session{}} = GroupSession.delete_session(session)
      assert_raise Ecto.NoResultsError, fn -> GroupSession.get_session!(session.id) end
    end

    test "change_session/1 returns a session changeset" do
      session = session_fixture()
      assert %Ecto.Changeset{} = GroupSession.change_session(session)
    end
  end
end
