defmodule Medix.Repo do
  use Ecto.Repo,
    otp_app: :medix,
    adapter: Ecto.Adapters.Postgres
end
