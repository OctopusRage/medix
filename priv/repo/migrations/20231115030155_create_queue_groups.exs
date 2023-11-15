defmodule Medix.Repo.Migrations.CreateQueueGroups do
  use Ecto.Migration

  def change do
    create table(:queue_groups) do
      add :name, :string
      add :descriptions, :string
      add :deleted_at, :utc_datetime, nullable: true

      timestamps(type: :utc_datetime)
    end
  end
end
