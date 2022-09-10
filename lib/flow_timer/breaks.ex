defmodule FlowTimer.Breaks do
  @moduledoc """
  The Breaks context.
  """

  import Ecto.Query, warn: false
  alias FlowTimer.Repo

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
end
