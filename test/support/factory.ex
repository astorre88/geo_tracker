defmodule GeoTracker.Factory do
  use ExMachina.Ecto, repo: GeoTracker.Repo

  alias GeoTracker.Auth
  alias GeoTracker.Accounts.Token
  alias GeoTracker.Geo.Point
  alias GeoTracker.Tasks.Task

  def token_factory do
    %Token{value: Auth.generate_token()}
  end

  def task_factory do
    %Task{pickup: Point.from_coordinates(55.817566, 37.491528), delivery: Point.from_coordinates(55.746081, 37.487730)}
  end
end
