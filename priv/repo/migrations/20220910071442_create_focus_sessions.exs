defmodule FlowTimer.Repo.Migrations.CreateFocusSessions do
  use Ecto.Migration

  def change do
    create table(:focus_sessions) do
      add :number, :integer
      add :finished_at, :naive_datetime
      add :task_id, references(:tasks, on_delete: :nothing)

      timestamps()
    end

    create index(:focus_sessions, [:task_id])
  end
end
