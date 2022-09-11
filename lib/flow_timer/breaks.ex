defmodule FlowTimer.Breaks do
  @moduledoc """
  The Breaks context.
  """

  import Ecto.Query, warn: false
  alias FlowTimer.Repo

  alias FlowTimer.Accounts.User
  alias FlowTimer.Breaks.Break

  @doc """
  Returns the list of breaks.

  ## Examples

      iex> list_breaks()
      [%Break{}, ...]

  """
  def list_breaks do
    Repo.all(Break)
  end

  @doc """
  Gets a single break.

  Raises `Ecto.NoResultsError` if the Break does not exist.

  ## Examples

      iex> get_break!(123)
      %Break{}

      iex> get_break!(456)
      ** (Ecto.NoResultsError)

  """
  def get_break!(id), do: Repo.get!(Break, id)

  @doc """
  Creates a break.

  ## Examples

      iex> create_break(%{field: value})
      {:ok, %Break{}}

      iex> create_break(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_break(attrs \\ %{}) do
    %Break{}
    |> Break.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a break.

  ## Examples

      iex> update_break(break, %{field: new_value})
      {:ok, %Break{}}

      iex> update_break(break, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_break(%Break{} = break, attrs) do
    break
    |> Break.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a break.

  ## Examples

      iex> delete_break(break)
      {:ok, %Break{}}

      iex> delete_break(break)
      {:error, %Ecto.Changeset{}}

  """
  def delete_break(%Break{} = break) do
    Repo.delete(break)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking break changes.

  ## Examples

      iex> change_break(break)
      %Ecto.Changeset{data: %Break{}}

  """
  def change_break(%Break{} = break, attrs \\ %{}) do
    Break.changeset(break, attrs)
  end

  @spec default_settings() :: map
  def default_settings do
    [
      %{limit: 25 * 60, minutes: 3},
      %{limit: 40 * 60, minutes: 5},
      %{limit: 60 * 60, minutes: 7},
      %{limit: 80 * 60, minutes: 10},
      %{limit: 0, minutes: 15}
    ]
  end

  @spec break_duration_till_end(Break.t()) :: non_neg_integer()
  def break_duration_till_end(%Break{finished_at: finished_at}) do
    NaiveDateTime.diff(finished_at, NaiveDateTime.utc_now())
  end

  @spec break_duration(Break.t()) :: non_neg_integer()
  def break_duration(%Break{finished_at: finished_at} = break) do
    NaiveDateTime.diff(finished_at, break.inserted_at)
  end

  @spec get_active_break(User.t()) :: Break.t() | nil
  def get_active_break(%User{id: user_id}) do
    query =
      from b in Break,
        join: fs in assoc(b, :focus_session),
        join: t in assoc(fs, :task),
        where: t.user_id == ^user_id,
        where: b.finished_at >= ^NaiveDateTime.utc_now(),
        where: b.finished == false,
        limit: 1

    Repo.one(query)
  end
end
