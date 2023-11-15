defmodule Medix.Groups.QueueGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "queue_groups" do
    field :descriptions, :string
    field :name, :string
    field :deleted_at, :utc_datetime, default: nil

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(queue_group, attrs) do
    queue_group
    |> cast(attrs, [:name, :descriptions])
    |> validate_required([:name])
  end
end
