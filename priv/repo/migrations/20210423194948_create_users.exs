defmodule GeoTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :token, :string

      timestamps()
    end

    create unique_index(:users, [:token])
  end
end
