defmodule FlowTimer.FocusSessionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FlowTimer.FocusSessions` context.
  """

  @doc """
  Generate a focus_session.
  """
  def focus_session_fixture(attrs \\ %{}) do
    {:ok, focus_session} =
      attrs
      |> Enum.into(%{
        finished_at: ~N[2022-09-09 07:14:00],
        number: 42
      })
      |> FlowTimer.FocusSessions.create_focus_session()

    focus_session
  end
end
