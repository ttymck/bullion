defmodule Bullion.Game do
  use Ecto.Schema
  import Ecto.Changeset
  import Hashids
  @timestamps_opts [type: :utc_datetime]

  @hashid_salt "28947"

  schema "game" do
    field :name, :string
    field :buyin_dollars, :integer
    field :buyin_chips, :integer
    field :shortcode, :string, virtual: true
    has_many :players, Bullion.Player
    timestamps()
  end

  def changeset(game, %{} = params \\ %{}) do
    game
    |> cast(params, [:name, :buyin_dollars, :buyin_chips])
    |> validate_required([:name, :buyin_dollars, :buyin_chips])
  end

  def put_shortcode(game) do
    %Bullion.Game{game | shortcode: shortcode_for_game(game)}
  end

  defp hashid() do
    Hashids.new(
      salt: @hashid_salt, 
      alphabet: "abcdefghijklmnopqrstuvwxyz0123456789",
      min_len: 6)
  end

  def id_for_shortcode(shortcode) do
    hashid
    |> Hashids.decode(shortcode)
  end

  def shortcode_for_id(id) when is_binary(id) do
    {id, _} = Integer.parse(id)
    shortcode_for_id(id)
  end

  def shortcode_for_id(id) when is_number(id) do
    hashid
    |> Hashids.encode(id)
  end

  def shortcode_for_game(game) do 
    hashid
    |> Hashids.encode(game.id)
  end

end