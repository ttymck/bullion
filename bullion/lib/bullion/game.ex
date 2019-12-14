defmodule Bullion.Game do
  use Ecto.Schema

  @timestamps_opts [type: :utc_datetime]

  schema "game" do
    field :shortcode, :string
    field :buyin_dollars, :integer
    field :buyin_chips, :integer
    timestamps()
  end

  def changeset(game, params \\ %{}) do
    game
    |> Ecto.Changeset.cast(params, [:shortcode, :buyin_dollars, :buyin_chips])
    |> Ecto.Changeset.validate_required([:shortcode, :buyin_dollars, :buyin_chips])
  end
end