defmodule DBListener.Repo do
  use Ecto.Repo,
    otp_app: :db_listener,
    adapter: Ecto.Adapters.Postgres
end
