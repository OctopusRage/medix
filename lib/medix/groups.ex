defmodule Medix.Groups do
  @moduledoc """
  The Groups context.
  """

  import Ecto.Query, warn: false
  alias Medix.Repo

  alias Medix.Groups.QueueGroup

  @doc """
  Returns the list of queue_groups.

  ## Examples

      iex> list_queue_groups()
      [%QueueGroup{}, ...]

  """
  def list_queue_groups do
    Repo.all(QueueGroup |> order_by(desc: :id))
  end

  @doc """
  Gets a single queue_group.

  Raises `Ecto.NoResultsError` if the Queue group does not exist.

  ## Examples

      iex> get_queue_group!(123)
      %QueueGroup{}

      iex> get_queue_group!(456)
      ** (Ecto.NoResultsError)

  """
  def get_queue_group!(id), do: Repo.get!(QueueGroup, id)

  @doc """
  Creates a queue_group.

  ## Examples

      iex> create_queue_group(%{field: value})
      {:ok, %QueueGroup{}}

      iex> create_queue_group(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_queue_group(attrs \\ %{}) do
    %QueueGroup{}
    |> QueueGroup.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a queue_group.

  ## Examples

      iex> update_queue_group(queue_group, %{field: new_value})
      {:ok, %QueueGroup{}}

      iex> update_queue_group(queue_group, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_queue_group(%QueueGroup{} = queue_group, attrs) do
    queue_group
    |> QueueGroup.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a queue_group.

  ## Examples

      iex> delete_queue_group(queue_group)
      {:ok, %QueueGroup{}}

      iex> delete_queue_group(queue_group)
      {:error, %Ecto.Changeset{}}

  """
  def delete_queue_group(%QueueGroup{} = queue_group) do
    Repo.delete(queue_group)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking queue_group changes.

  ## Examples

      iex> change_queue_group(queue_group)
      %Ecto.Changeset{data: %QueueGroup{}}

  """
  def change_queue_group(%QueueGroup{} = queue_group, attrs \\ %{}) do
    QueueGroup.changeset(queue_group, attrs)
  end
end
