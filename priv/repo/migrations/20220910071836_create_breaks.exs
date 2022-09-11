defmodule FlowTimer.Repo.Migrations.CreateBreaks do
  use Ecto.Migration

  def change do
    create table(:breaks) do
      add :finished_at, :naive_datetime
      add :finished, :boolean
      add :focus_session_id, references(:focus_sessions, on_delete: :nothing)

      timestamps()
    end

    create index(:breaks, [:focus_session_id])
  end
end
