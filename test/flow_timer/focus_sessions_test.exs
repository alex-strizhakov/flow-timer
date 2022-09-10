defmodule FlowTimer.FocusSessionsTest do
  use FlowTimer.DataCase

  alias FlowTimer.FocusSessions

  describe "focus_sessions" do
    alias FlowTimer.FocusSessions.FocusSession

    import FlowTimer.FocusSessionsFixtures

    @invalid_attrs %{finished_at: nil, number: nil}

    test "list_focus_sessions/0 returns all focus_sessions" do
      focus_session = focus_session_fixture()
      assert FocusSessions.list_focus_sessions() == [focus_session]
    end

    test "get_focus_session!/1 returns the focus_session with given id" do
      focus_session = focus_session_fixture()
      assert FocusSessions.get_focus_session!(focus_session.id) == focus_session
    end

    test "create_focus_session/1 with valid data creates a focus_session" do
      valid_attrs = %{finished_at: ~N[2022-09-09 07:14:00], number: 42}

      assert {:ok, %FocusSession{} = focus_session} = FocusSessions.create_focus_session(valid_attrs)
      assert focus_session.finished_at == ~N[2022-09-09 07:14:00]
      assert focus_session.number == 42
    end

    test "create_focus_session/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FocusSessions.create_focus_session(@invalid_attrs)
    end

    test "update_focus_session/2 with valid data updates the focus_session" do
      focus_session = focus_session_fixture()
      update_attrs = %{finished_at: ~N[2022-09-10 07:14:00], number: 43}

      assert {:ok, %FocusSession{} = focus_session} = FocusSessions.update_focus_session(focus_session, update_attrs)
      assert focus_session.finished_at == ~N[2022-09-10 07:14:00]
      assert focus_session.number == 43
    end

    test "update_focus_session/2 with invalid data returns error changeset" do
      focus_session = focus_session_fixture()
      assert {:error, %Ecto.Changeset{}} = FocusSessions.update_focus_session(focus_session, @invalid_attrs)
      assert focus_session == FocusSessions.get_focus_session!(focus_session.id)
    end

    test "delete_focus_session/1 deletes the focus_session" do
      focus_session = focus_session_fixture()
      assert {:ok, %FocusSession{}} = FocusSessions.delete_focus_session(focus_session)
      assert_raise Ecto.NoResultsError, fn -> FocusSessions.get_focus_session!(focus_session.id) end
    end

    test "change_focus_session/1 returns a focus_session changeset" do
      focus_session = focus_session_fixture()
      assert %Ecto.Changeset{} = FocusSessions.change_focus_session(focus_session)
    end
  end
end
