defmodule FlowTimerWeb.PageController do
  use FlowTimerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
