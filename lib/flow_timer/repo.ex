defmodule FlowTimer.Repo do
  use Ecto.Repo,
    otp_app: :flow_timer,
    adapter: Ecto.Adapters.Postgres
end
