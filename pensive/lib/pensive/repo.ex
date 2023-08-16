defmodule Pensive.Repo do
  use Ecto.Repo,
    otp_app: :pensive,
    adapter: Ecto.Adapters.Postgres
end
