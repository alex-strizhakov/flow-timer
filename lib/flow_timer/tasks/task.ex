defmodule FlowTimer.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string

    belongs_to :user, FlowTimer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:user_id])
    |> foreign_key_constraint(:user_id)
  end
end
