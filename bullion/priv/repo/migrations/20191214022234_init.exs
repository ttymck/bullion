defmodule Bullion.Repo.Migrations.Init do
  use Ecto.Migration

  def change do
    create table(:game) do
      add :name, :string, null: false
      add :buyin_dollars, :integer
      add :buyin_chips, :integer
      timestamps([type: :utc_datetime])
    end

    create table(:player) do
      add :name, :string, null: false
      add :game_id, references(:game)
      add :buyin_count, :integer
      timestamps([type: :utc_datetime])
    end

  end
end
