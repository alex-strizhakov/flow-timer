defmodule FlowTimer.BreaksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FlowTimer.Breaks` context.
  """

  @doc """
  Generate a break.
  """
  def break_fixture(attrs \\ %{}) do
    {:ok, break} =
      attrs
      |> Enum.into(%{
        finished_at: ~N[2022-09-09 07:18:00]
      })
      |> FlowTimer.Breaks.create_break()

    break
  end
end
