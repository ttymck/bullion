defmodule Bullion.Repo do
  use Ecto.Repo,
    otp_app: :bullion,
    adapter: Ecto.Adapters.Postgres
end
