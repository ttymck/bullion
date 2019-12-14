defmodule Bullion.Repo.Migrations.Init do
  use Ecto.Migration

  def change do
    create table(:game) do
      add :shortcode, :string
      add :buyin_dollars, :integer
      add :buyin_chips, :integer
      
      timestamps([type: :utc_datetime])
    end

    create unique_index(:game, [:shortcode])
  end
end
