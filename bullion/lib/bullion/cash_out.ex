defmodule Bullion.CashOut do
  use Ecto.Schema
  import Ecto.Changeset
  
  @timestamps_opts [type: :utc_datetime]

  schema "cash_out" do
    field :chip_count, :integer
    belongs_to :player, Bullion.Player
    timestamps()
  end

  def changeset(cash_out, params \\ %{}) do
    cash_out
    |> Ecto.Changeset.cast(params, [:chip_count, :player_id])
    |> Ecto.Changeset.validate_required([:chip_count, :player_id])
  end
end