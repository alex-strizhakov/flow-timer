defmodule FlowTimerWeb.UserLiveAuth do
  import Phoenix.LiveView

  alias FlowTimerWeb.Router.Helpers, as: Routes

  def on_mount(:default, _params, %{"user_token" => token}, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        FlowTimer.Accounts.get_user_by_session_token(token)
      end)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: Routes.user_session_path(socket, :new))}
    end
  end
end
