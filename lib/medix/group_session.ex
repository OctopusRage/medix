defmodule Medix.GroupSession do
  alias Ecto.Multi

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
  def get_session!(id), do: Repo.get!(Session, id) |> Repo.preload(:queues)

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

  def have_active_queue?(group_id) when is_binary(group_id),
    do: String.to_integer(group_id) |> have_active_queue?()

  def have_active_queue?(group_id) do
    Session |> where([s], s.queue_group_id == ^group_id and s.status == 1) |> Repo.exists?()
  end

  def mark_as_done(session) do
    session |> update_session(%{status: 2, resolved_at: DateTime.utc_now()})
  end

  def start_session(session) do
    session |> update_session(%{status: 1, started_at: DateTime.utc_now()})
  end

  @doc """
  Returns the list of queues.

  ## Examples

      iex> list_queues()
      [%Queue{}, ...]

  """
  def list_queues do
    Repo.all(Queue)
  end

  def list_queues(session_id) do
    Queue |> where([q], q.session_id == ^session_id) |> Repo.all()
  end

  def get_queue!(id), do: Repo.get!(Queue, id)

  def add_queue(session, attrs \\ %{}) do
    case Multi.new()
         |> Multi.run(:last_queue, fn repo, _ ->
           case Queue
                |> where([q], q.session_id == ^session.id)
                |> order_by(desc: :id)
                |> limit(1)
                |> repo.one() do
             nil ->
               number = 1
               {:ok, attrs |> Map.merge(%{"number" => number})}

             q ->
               number = q.number + 1
               {:ok, attrs |> Map.merge(%{"number" => number})}
           end
         end)
         |> Multi.run(:queue, fn repo, %{last_queue: changes} ->
           Queue.changeset(%Queue{}, changes) |> repo.insert()
         end)
         |> Repo.transaction() do
      {:ok, %{queue: queue}} -> {:ok, queue}
      {:error, _, err_val, _changes} -> {:error, err_val}
    end
  end

  def next_queue(session) do
    tx =
      Multi.new()
      |> Multi.run(:current_queue, fn repo, _ ->
        current_queue =
          Queue
          |> where([q], q.session_id == ^session.id and q.status == 1)
          |> limit(1)
          |> repo.one()

        if current_queue, do: {:ok, current_queue}, else: {:error, "no current queue"}
      end)
      |> Multi.run(:next_queue, fn repo, multi ->
        next_queue =
          Queue
          |> where(
            [q],
            q.session_id == ^session.id and q.number == ^multi.current_queue.number + 1
          )
          |> limit(1)
          |> repo.one()

        if next_queue, do: {:ok, next_queue}, else: {:error, "Cant go to next queue"}
      end)
      |> Multi.update(:update_c_queue, fn %{current_queue: q} ->
        Queue.changeset(q, %{status: 0})
      end)
      |> Multi.update(:update_queue, fn %{next_queue: q} ->
        Queue.changeset(q, %{status: 1})
      end)
      |> Repo.transaction()

    case tx do
      {:ok, %{update_queue: queue}} -> {:ok, queue}
      {:error, _, err_val, _changes} -> {:error, err_val}
    end
  end

  def update_queue(%Queue{} = queue, attrs) do
    queue
    |> Queue.changeset(attrs)
    |> Repo.update()
  end

  def delete_queue(%Queue{} = queue) do
    Repo.delete(queue)
  end

  def change_queue(queue, attrs \\ %{}) do
    queue =
      case queue do
        %Queue{} -> queue
        %{} -> %Queue{}
      end

    Queue.changeset(queue, attrs)
  end
end
