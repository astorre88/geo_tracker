defmodule GeoTracker.Repo.Migrations.CreateTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :value, :string, null: false
      add :role, :integer, null: false

      timestamps()
    end

    create unique_index(:tokens, [:value])
  end
end
