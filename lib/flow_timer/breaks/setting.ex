defmodule FlowTimer.Breaks.Setting do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :limit, :integer
    field :minutes, :integer
  end

  @doc false
  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:limit, :minutes])
    |> validate_required([:limit, :minutes])
  end
end
