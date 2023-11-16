defmodule Medix.GroupSession do
  @moduledoc """
  The GroupSession context.
  """

  import Ecto.Query, warn: false
  alias Medix.Repo

  alias Medix.GroupSession.{Session, Queue}

  @doc """
  Returns the list of sessions.

  ## Examples

      iex> list_sessions()
      [%Session{}, ...]

  """
  def list_sessions do
    Repo.all(Session)
  end

  def list_sessions(group_id) do
    Session |> where([s], s.queue_group_id == ^group_id) |> order_by(desc: :id) |> Repo.all()
  end

  @doc """
  Gets a single session.

  Raises `Ecto.NoResultsError` if the Session does not exist.

  ## Examples

      iex> get_session!(123)
      %Session{}

      iex> get_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_session!(id), do: Repo.get!(Session, id)

  @doc """
  Creates a session.

  ## Examples

      iex> create_session(%{field: value})
      {:ok, %Session{}}

      iex> create_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session(attrs \\ %{}) do
    %Session{}
    |> Session.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session.

  ## Examples

      iex> update_session(session, %{field: new_value})
      {:ok, %Session{}}

      iex> update_session(session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_session(%Session{} = session, attrs) do
    session
    |> Session.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a session.

  ## Examples

      iex> delete_session(session)
      {:ok, %Session{}}

      iex> delete_session(session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_session(%Session{} = session) do
    Repo.delete(session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session changes.

  ## Examples

      iex> change_session(session)
      %Ecto.Changeset{data: %Session{}}

  """
  def change_session(%Session{} = session, attrs \\ %{}) do
    Session.changeset(session, attrs)
  end

  def show_queues(session_id) do
    Queue |> where([q], q.session_id == ^session_id) |> Repo.all()
  end

  def have_active_queue?(group_id) when is_binary(group_id), do: String.to_integer(group_id) |> have_active_queue?()
  def have_active_queue?(group_id) do
    Session |> where([s], s.queue_group_id == ^group_id and s.status == 1) |> Repo.exists?
  end

  def mark_as_done(session) do
    session |> update_session(%{status: 2, resolved_at: DateTime.utc_now()})
  end
end
