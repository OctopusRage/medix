defmodule Medix.GroupSession.Session do
  use Ecto.Schema
  import Ecto.Changeset

  # @status_waiting 0
  # @status_started 1
  # @status_done 2

  schema "sessions" do
    field :name, :string
    field :status, :integer
    field :started_at, :utc_datetime
    belongs_to :queue_group, Medix.Groups.QueueGroup
    has_many :queues, Medix.GroupSession.Queue

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:name, :queue_group_id, :status])
    |> add_name_if_missing()
    |> add_started_at_if_start()
    |> validate_required([:name, :queue_group_id, :status])
    |> validate_inclusion(:status, [0,1,2])
  end


  defp add_name_if_missing(changeset) do
    case get_field(changeset, :name) do
      nil -> put_change(changeset, :name, default_name())
      _ -> changeset
    end
  end

  defp add_started_at_if_start(changeset) do
    case get_field(changeset, :status) do
      1 ->
        now = DateTime.utc_now() |> DateTime.truncate(:second)
        put_change(changeset, :started_at, now)
      _ -> changeset
    end
  end

  defp default_name() do
    DateTime.utc_now()
  end
end
