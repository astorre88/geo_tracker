import EctoEnum, only: [defenum: 2]
defenum(GeoTracker.StateEnum, new: 0, assigned: 1, done: 2)

defmodule GeoTracker.Tasks.Task do
  use Ecto.Schema

  import Ecto.Changeset

  alias GeoTracker.StateEnum

  schema "tasks" do
    field :state, StateEnum, default: 0
    field :pickup, Geo.PostGIS.Geometry
    field :delivery, Geo.PostGIS.Geometry

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:state, :pickup, :delivery])
    |> validate_required([:pickup, :delivery])
  end
end
