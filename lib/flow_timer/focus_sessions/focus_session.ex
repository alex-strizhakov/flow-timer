defmodule FlowTimer.FocusSessions.FocusSession do
  use Ecto.Schema
  import Ecto.Changeset

  schema "focus_sessions" do
    field :finished_at, :naive_datetime
    field :number, :integer
    field :task_id, :id

    timestamps()
  end

  @doc false
  def changeset(focus_session, attrs) do
    focus_session
    |> cast(attrs, [:number, :finished_at])
    |> validate_required([:number, :finished_at])
  end
end
