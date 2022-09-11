defmodule FlowTimer.FocusSessions.FocusSession do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}
  schema "focus_sessions" do
    field :finished_at, :naive_datetime
    field :number, :integer
    belongs_to :task, FlowTimer.Tasks.Task
    has_one :break, FlowTimer.Breaks.Break

    timestamps()
  end

  @doc false
  def changeset(focus_session, attrs) do
    focus_session
    |> cast(attrs, [:number, :finished_at, :task_id])
    |> validate_required([:number, :task_id])
  end
end
