defmodule FlowTimer.Breaks.Break do
  use Ecto.Schema
  import Ecto.Changeset

  schema "breaks" do
    field :finished_at, :naive_datetime
    field :focus_session_id, :id

    timestamps()
  end

  @doc false
  def changeset(break, attrs) do
    break
    |> cast(attrs, [:finished_at])
    |> validate_required([:finished_at])
  end
end
