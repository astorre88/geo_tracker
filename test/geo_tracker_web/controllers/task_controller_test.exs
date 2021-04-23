defmodule GeoTrackerWeb.TaskControllerTest do
  use GeoTrackerWeb.ConnCase

  import GeoTracker.Factory

  alias GeoTracker.Geo.Point
  alias GeoTracker.Tasks.Task

  @create_attrs %{
    pickup: Point.from_coordinates(55.817566, 37.491528),
    delivery: Point.from_coordinates(55.746081, 37.487730)
  }
  @invalid_attrs %{pickup: nil, delivery: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, Routes.task_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create task" do
    test "renders task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task: @create_attrs)

      assert %{
               "id" => _,
               "state" => "new",
               "pickup" => %{"coordinates" => [55.817566, 37.491528]},
               "delivery" => %{"coordinates" => [55.746081, 37.48773]}
             } = json_response(conn, 201)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup do
      %{task: insert(:task)}
    end

    test "successfully picks a task", %{conn: conn, task: %Task{id: id} = task} do
      conn = patch(conn, Routes.task_path(conn, :pick, task))
      assert %{"id" => ^id, "state" => "assigned"} = json_response(conn, 200)["data"]
    end

    test "successfully finishes a task", %{conn: conn, task: %Task{id: id} = task} do
      conn = patch(conn, Routes.task_path(conn, :finish, task))
      assert %{"id" => ^id, "state" => "done"} = json_response(conn, 200)["data"]
    end
  end
end
