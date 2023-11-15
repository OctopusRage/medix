defmodule Medix.GroupSession.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do
    field :name, :string
    belongs_to :queue_group, Medix.Groups.QueueGroup

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [:name, :queue_group_id])
    |> add_name_if_missing()
    |> validate_required([:name, :queue_group_id])
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
