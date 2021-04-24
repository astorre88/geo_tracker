defmodule GeoTracker.Tasks.Queries.Task do
  @moduledoc false

  import Ecto.Query, warn: false

  def by_distance(query, %Geo.Point{coordinates: {lon, lat}, srid: srid}) do
    from(t in query, order_by: fragment("? <-> ST_SetSRID(ST_MakePoint(?,?), ?)", t.pickup, ^lon, ^lat, ^srid))
  end
end
