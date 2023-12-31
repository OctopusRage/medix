defmodule Medix.GroupSessionFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Medix.GroupSession` context.
  """

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Medix.GroupSession.create_session()

    session
  end
end
