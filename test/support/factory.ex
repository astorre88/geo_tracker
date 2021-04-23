defmodule GeoTracker.Factory do
  use ExMachina.Ecto, repo: GeoTracker.Repo

  alias GeoTracker.Accounts.User
  alias GeoTracker.Geo.Point
  alias GeoTracker.Tasks.Task

  def user_factory do
    %User{}
  end

  def task_factory do
    %Task{pickup: Point.from_coordinates(55.817566, 37.491528), delivery: Point.from_coordinates(55.746081, 37.487730)}
  end
end
