import EctoEnum, only: [defenum: 2]
defenum(GeoTracker.StateEnum, new: 0, assigned: 1, done: 2)

defmodule GeoTracker.Tasks.Task do
  use Ecto.Schema

  import Ecto.Changeset

  alias GeoTracker.Geo.Point
  alias GeoTracker.StateEnum

  @required_attrs ~w(lat1 long1 lat2 long2)a
  @optional_attrs ~w(state)a

  schema "tasks" do
    field :state, StateEnum, read_after_writes: true
    field :lat1, :float, virtual: true
    field :long1, :float, virtual: true
    field :lat2, :float, virtual: true
    field :long2, :float, virtual: true
    field :pickup, Geo.PostGIS.Geometry
    field :delivery, Geo.PostGIS.Geometry

    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, @optional_attrs ++ @required_attrs)
    |> validate_required(@required_attrs)
    |> parse_coordinates()
  end

  def update_changeset(task, attrs) do
    task
    |> cast(attrs, @optional_attrs)
    |> validate_required(@optional_attrs)
  end

  defp parse_coordinates(
         %Ecto.Changeset{
           valid?: true,
           changes: %{
             lat1: pickup_lat,
             long1: pickup_lon,
             lat2: delivery_lat,
             long2: delivery_lon
           }
         } = changeset
       ) do
    changeset
    |> put_change(:pickup, Point.from_coordinates(pickup_lat, pickup_lon))
    |> put_change(:delivery, Point.from_coordinates(delivery_lat, delivery_lon))
  end

  defp parse_coordinates(changeset), do: changeset
end
