defmodule Medix.GroupSession.Queue do
  use Ecto.Schema
  import Ecto.Changeset

  schema "queues" do
    field :number, :integer
    field :name, :string
    field :customer_id, :integer
    field :status, :integer
    field :notes, :integer

    belongs_to :session, Medix.GroupSession.Session

    field :deleted_at, :utc_datetime
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(queue, attrs) do
    queue
    |> cast(attrs, [:name, :number, :customer_id, :status, :notes, :session_id])
    |> add_name_if_missing()
    |> validate_required([:name, :session_id, :number])
  end


  defp add_name_if_missing(changeset) do
    case get_field(changeset, :name) do
      nil -> put_change(changeset, :name, default_name())
      _ -> changeset
    end
  end

  defp default_name() do
    DateTime.utc_now()
  end
end
