defmodule Medix.Repo.Migrations.CreateQueuesTable do
  use Ecto.Migration

  def change do
    create table(:queues) do
      add :session_id, :bigint
      add :number, :integer, nullable: false

      add :name, :string, nullable: true
      add :customer_identity, :string, nullable: true
      add :status, :integer, nullable: false
      add :notes, :text

      add :deleted_at, :utc_datetime, nullable: true


      timestamps(type: :utc_datetime)
    end

    create unique_index(:queues, [:session_id, :number])
  end
end
