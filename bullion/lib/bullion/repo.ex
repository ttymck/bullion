defmodule Bullion.Repo do
  use Ecto.Repo,
    otp_app: :bullion,
    adapter: Ecto.Adapters.Postgres

  def init(_, config) do
    config = config
      |> Keyword.put(:url, System.get_env("DATABASE_URL"))
    {:ok, config}
  end
end
