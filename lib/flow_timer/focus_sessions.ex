defmodule FlowTimer.FocusSessions do
  @moduledoc """
  The FocusSessions context.
  """

  import Ecto.Query, warn: false
  alias FlowTimer.Repo

  alias FlowTimer.Accounts.User
  alias FlowTimer.FocusSessions.FocusSession

  @doc """
  Returns the list of focus_sessions.

  ## Examples

      iex> list_focus_sessions()
      [%FocusSession{}, ...]

  """
  def list_focus_sessions do
    Repo.all(FocusSession)
  end

  defp today_midnight, do: NaiveDateTime.new!(Date.utc_today(), Time.new!(0, 0, 0))
  @spec list_today_finished_sessions(User.t()) :: [FocusSession.t()]
  def list_today_finished_sessions(%User{id: user_id}) do
    query =
      from fs in FocusSession,
        join: t in assoc(fs, :task),
        preload: [task: t],
        where: t.user_id == ^user_id,
        where: fs.inserted_at >= ^today_midnight(),
        where: not is_nil(fs.finished_at),
        order_by: [desc: fs.inserted_at]

    Repo.all(query)
  end

  @spec get_active_focus_session(User.t()) :: FocusSession.t() | nil
  def get_active_focus_session(%User{id: user_id}) do
    query =
      from fs in FocusSession,
        join: t in assoc(fs, :task),
        preload: [task: t],
        where: t.user_id == ^user_id,
        where: fs.inserted_at >= ^today_midnight(),
        where: is_nil(fs.finished_at),
        limit: 1

    Repo.one(query)
  end

  @spec session_duration(FocusSession.t()) :: non_neg_integer()
  def session_duration(%FocusSession{finished_at: %NaiveDateTime{} = finished_at} = session) do
    NaiveDateTime.diff(finished_at, session.inserted_at)
  end

  def session_duration(%FocusSession{} = session) do
    NaiveDateTime.diff(NaiveDateTime.utc_now(), session.inserted_at)
  end

  @doc """
  Gets a single focus_session.

  Raises `Ecto.NoResultsError` if the Focus session does not exist.

  ## Examples

      iex> get_focus_session!(123)
      %FocusSession{}

      iex> get_focus_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_focus_session!(id), do: Repo.get!(FocusSession, id)

  @doc """
  Creates a focus_session.

  ## Examples

      iex> create_focus_session(%{field: value})
      {:ok, %FocusSession{}}

      iex> create_focus_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_focus_session(attrs \\ %{}) do
    %FocusSession{}
    |> FocusSession.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a focus_session.

  ## Examples

      iex> update_focus_session(focus_session, %{field: new_value})
      {:ok, %FocusSession{}}

      iex> update_focus_session(focus_session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_focus_session(%FocusSession{} = focus_session, attrs) do
    focus_session
    |> FocusSession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a focus_session.

  ## Examples

      iex> delete_focus_session(focus_session)
      {:ok, %FocusSession{}}

      iex> delete_focus_session(focus_session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_focus_session(%FocusSession{} = focus_session) do
    Repo.delete(focus_session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking focus_session changes.

  ## Examples

      iex> change_focus_session(focus_session)
      %Ecto.Changeset{data: %FocusSession{}}

  """
  def change_focus_session(%FocusSession{} = focus_session, attrs \\ %{}) do
    FocusSession.changeset(focus_session, attrs)
  end
end
