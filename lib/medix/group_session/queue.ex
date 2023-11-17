defmodule Medix.GroupSession.Queue do
  use Ecto.Schema
  import Ecto.Changeset

  # status 0 waiting
  # status 1 served
  # status 2 cancelled
  schema "queues" do
    field :number, :integer
    field :name, :string
    field :customer_identity, :string
    field :status, :integer, default: 0
    field :notes, :integer

    belongs_to :session, Medix.GroupSession.Session

    field :deleted_at, :utc_datetime
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(queue, attrs) do
    queue
    |> cast(attrs, [:name, :number, :customer_identity, :status, :notes, :session_id])
    |> validate_required([:name, :session_id])
  end

end
