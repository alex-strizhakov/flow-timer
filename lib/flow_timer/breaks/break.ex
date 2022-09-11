defmodule FlowTimer.Breaks.Break do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{}

  schema "breaks" do
    field :finished_at, :naive_datetime
    field :finished, :boolean, default: false

    belongs_to :focus_session, FlowTimer.FocusSessions.FocusSession

    timestamps()
  end

  @doc false
  def changeset(break, attrs) do
    break
    |> cast(attrs, [:finished_at, :focus_session_id, :finished])
    |> validate_required([:focus_session_id, :finished_at])
  end
end
