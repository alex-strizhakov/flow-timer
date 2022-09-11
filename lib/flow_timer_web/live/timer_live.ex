defmodule FlowTimerWeb.TimerLive do
  use FlowTimerWeb, :live_view

  require Logger

  alias FlowTimer.Breaks
  alias FlowTimer.FocusSessions
  alias FlowTimer.Tasks
  alias FlowTimer.Tasks.Task

  @impl true
  def mount(_params, _session, socket) do
    %{current_user: user} = socket.assigns
    changeset = Tasks.change_task(%Task{})

    finished_sessions = FocusSessions.list_today_finished_sessions(user)
    active_session = FocusSessions.get_active_focus_session(user)
    break = Breaks.get_active_break(user)

    socket =
      assign(socket,
        changeset: changeset,
        focus_session: active_session,
        timer_ref: nil,
        timer: nil,
        finished_sessions: finished_sessions,
        break_settings: Map.new(user.break_settings, &{&1.limit, &1.minutes}),
        break: break
      )

    socket =
      cond do
        break ->
          {:ok, timer_ref} = :timer.send_interval(1_000, :tick)
          assign(socket, timer: timer_from_break(break), timer_ref: timer_ref)

        active_session ->
          {:ok, timer_ref} = :timer.send_interval(1_000, :tick)
          assign(socket, timer: timer_from_session(active_session), timer_ref: timer_ref)

        true ->
          socket
      end

    {:ok, socket, temporary_assigns: [finished_sessions: []]}
  end

  @impl true
  def handle_event("start_session", %{"task" => task_params}, socket) do
    %{current_user: user} = socket.assigns
    task_params = Map.put(task_params, "user_id", user.id)

    count_finished_sessions = user |> FocusSessions.list_today_finished_sessions() |> length()

    socket =
      with {:ok, task} <- Tasks.create_task(task_params),
           {:ok, focus_session} <-
             FocusSessions.create_focus_session(%{
               task_id: task.id,
               number: count_finished_sessions + 1
             }) do
        focus_session = FlowTimer.Repo.preload(focus_session, :task)
        {:ok, timer_ref} = :timer.send_interval(1_000, :tick)

        assign(socket,
          focus_session: focus_session,
          timer_ref: timer_ref,
          timer: timer_from_session(focus_session)
        )
      else
        error ->
          Logger.error(inspect(error))
          put_flash(socket, :error, "Unexpected error occur")
      end

    {:noreply, socket}
  end

  def handle_event("stop_session", %{"session_id" => session_id}, socket) do
    %{break_settings: break_settings} = socket.assigns
    session = FocusSessions.get_focus_session!(session_id)
    now = NaiveDateTime.utc_now()

    {_, minutes} =
      break_settings
      |> Map.delete(0)
      |> Enum.sort()
      |> Enum.find({nil, break_settings[0]}, fn {limit, _} ->
        NaiveDateTime.diff(now, session.inserted_at) < limit
      end)

    socket =
      with {:ok, focus_session} <-
             FocusSessions.update_focus_session(session, %{finished_at: now}),
           {:ok, break} <-
             Breaks.create_break(%{
               focus_session_id: focus_session.id,
               finished_at: NaiveDateTime.add(now, minutes * 60)
             }) do
        session = FlowTimer.Repo.preload(focus_session, :task)

        assign(socket,
          focus_session: nil,
          timer: timer_from_break(break),
          break: break
        )
        |> update(:finished_sessions, fn sessions -> [session | sessions] end)
      else
        error ->
          Logger.error(inspect(error))
          put_flash(socket, :error, "Unexpected error occur")
      end

    {:noreply, socket}
  end

  def handle_event("continue_task", %{"task_id" => task_id}, socket) do
    %{current_user: user} = socket.assigns
    task = Tasks.get_task!(task_id)
    count_finished_sessions = user |> FocusSessions.list_today_finished_sessions() |> length()

    socket =
      case FocusSessions.create_focus_session(%{
             task_id: task.id,
             number: count_finished_sessions + 1
           }) do
        {:ok, focus_session} ->
          focus_session = FlowTimer.Repo.preload(focus_session, :task)
          {:ok, timer_ref} = :timer.send_interval(1_000, :tick)

          assign(socket,
            focus_session: focus_session,
            timer_ref: timer_ref,
            timer: timer_from_session(focus_session)
          )

        error ->
          Logger.error(inspect(error))
          put_flash(socket, :error, "Unexpected error occur")
      end

    {:noreply, socket}
  end

  def handle_event("stop_break", %{"break_id" => break_id}, socket) do
    break = Breaks.get_break!(break_id)

    socket =
      case Breaks.update_break(break, %{finished: true}) do
        {:ok, _} ->
          %{timer_ref: timer_ref} = socket.assigns
          {:ok, _} = :timer.cancel(timer_ref)
          assign(socket, timer: nil, break: nil, timer_ref: nil)

        error ->
          Logger.error(inspect(error))
          put_flash(socket, :error, "Unexpected error occur")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    %{focus_session: session, break: break} = socket.assigns

    timer =
      if break do
        timer_from_break(break)
      else
        timer_from_session(session)
      end

    {:noreply, assign(socket, timer: timer)}
  end

  def handle_info(:stop_break, socket) do
    %{timer_ref: timer_ref} = socket.assigns
    {:ok, _} = :timer.cancel(timer_ref)
    socket = assign(socket, timer: nil, break: nil, timer_ref: nil)
    {:noreply, socket}
  end

  defp timer_from_break(break) do
    break_duration = Breaks.break_duration_till_end(break)

    if break_duration == 0 do
      send(self(), :stop_break)
    end

    break_duration
    |> timer_from_duration()
  end

  defp timer_from_session(nil), do: nil

  defp timer_from_session(session) do
    session
    |> FocusSessions.session_duration()
    |> timer_from_duration()
  end

  defp timer_from_break_duration(break) do
    break
    |> Breaks.break_duration()
    |> timer_from_duration()
  end

  defp timer_from_duration(seconds) do
    hours = div(seconds, 3600)
    minutes = seconds |> minutes() |> maybe_add_leading_zero()
    seconds = seconds |> rem(3600) |> rem(60) |> maybe_add_leading_zero()
    "#{hours}:#{minutes}:#{seconds}"
  end

  defp minutes(seconds), do: seconds |> rem(3600) |> div(60)

  defp maybe_add_leading_zero(number) when number in 0..9, do: "0#{number}"
  defp maybe_add_leading_zero(number), do: number
end
