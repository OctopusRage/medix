defmodule Medix.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :name, :string, nullable: true
      add :queue_group_id, :bigint
      add :status, :integer, nullable: false
      add :started_at, :utc_datetime
      add :resolved_at, :utc_datetime

      add :deleted_at, :utc_datetime, nullable: true

      timestamps(type: :utc_datetime)
    end
  end
end
