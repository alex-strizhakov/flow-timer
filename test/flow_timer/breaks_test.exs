defmodule FlowTimer.BreaksTest do
  use FlowTimer.DataCase

  alias FlowTimer.Breaks

  describe "breaks" do
    alias FlowTimer.Breaks.Break

    import FlowTimer.BreaksFixtures

    @invalid_attrs %{finished_at: nil}

    test "list_breaks/0 returns all breaks" do
      break = break_fixture()
      assert Breaks.list_breaks() == [break]
    end

    test "get_break!/1 returns the break with given id" do
      break = break_fixture()
      assert Breaks.get_break!(break.id) == break
    end

    test "create_break/1 with valid data creates a break" do
      valid_attrs = %{finished_at: ~N[2022-09-09 07:18:00]}

      assert {:ok, %Break{} = break} = Breaks.create_break(valid_attrs)
      assert break.finished_at == ~N[2022-09-09 07:18:00]
    end

    test "create_break/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Breaks.create_break(@invalid_attrs)
    end

    test "update_break/2 with valid data updates the break" do
      break = break_fixture()
      update_attrs = %{finished_at: ~N[2022-09-10 07:18:00]}

      assert {:ok, %Break{} = break} = Breaks.update_break(break, update_attrs)
      assert break.finished_at == ~N[2022-09-10 07:18:00]
    end

    test "update_break/2 with invalid data returns error changeset" do
      break = break_fixture()
      assert {:error, %Ecto.Changeset{}} = Breaks.update_break(break, @invalid_attrs)
      assert break == Breaks.get_break!(break.id)
    end

    test "delete_break/1 deletes the break" do
      break = break_fixture()
      assert {:ok, %Break{}} = Breaks.delete_break(break)
      assert_raise Ecto.NoResultsError, fn -> Breaks.get_break!(break.id) end
    end

    test "change_break/1 returns a break changeset" do
      break = break_fixture()
      assert %Ecto.Changeset{} = Breaks.change_break(break)
    end
  end
end
