defmodule GeoTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :state, :integer, default: 0, null: false

      timestamps()
    end

    execute("SELECT AddGeometryColumn ('tasks','pickup',4326,'POINT',2)")
    execute("SELECT AddGeometryColumn ('tasks','delivery',4326,'POINT',2)")
    execute("CREATE INDEX tasks_pickup_index on tasks USING GIST (pickup)")
    execute("CREATE INDEX tasks_delivery_index on tasks USING GIST (delivery)")
  end
end
