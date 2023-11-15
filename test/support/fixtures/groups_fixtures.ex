defmodule Medix.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Medix.Groups` context.
  """

  @doc """
  Generate a queue_group.
  """
  def queue_group_fixture(attrs \\ %{}) do
    {:ok, queue_group} =
      attrs
      |> Enum.into(%{
        descriptions: "some descriptions",
        name: "some name"
      })
      |> Medix.Groups.create_queue_group()

    queue_group
  end
end
