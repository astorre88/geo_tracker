defmodule GeoTrackerWeb.TaskControllerTest do
  use GeoTrackerWeb.ConnCase

  import GeoTracker.Factory

  alias GeoTracker.Accounts.Token
  alias GeoTracker.Geo.Point
  alias GeoTracker.Tasks.Task

  @create_attrs %{
    lat1: 55.817566,
    long1: 37.491528,
    lat2: 55.746081,
    long2: 37.487730
  }
  @invalid_attrs %{lat1: nil, long1: nil, lat2: nil, long2: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup %{conn: conn} do
      %Token{value: driver_token_value} = insert(:token, role: :driver)

      {:ok, conn: put_req_header(conn, "authorization", "Bearer #{driver_token_value}")}
    end

    test "lists all tasks ordered by coordinates with pagination for driver", %{conn: conn} do
      # Kuzminki
      %Task{id: task1_id} = insert(:task, pickup: Point.from_coordinates(55.688011, 37.784089))
      # Fili
      insert(:task, pickup: Point.from_coordinates(55.749107, 37.491456))
      # Sokolniki
      insert(:task, pickup: Point.from_coordinates(55.801120, 37.671149))
      # Stockholm
      %Task{id: task4_id} = insert(:task, pickup: Point.from_coordinates(59.325000, 18.070897))

      conn = get(conn, Routes.task_path(conn, :index), lat: 55.817566, long: 37.491528, page: 2, page_size: 2)

      assert %{
               "data" => [%{"id" => ^task1_id}, %{"id" => ^task4_id}],
               "pagination" => %{"page_number" => 2, "page_size" => 2, "total_pages" => 2, "total_entries" => 4}
             } = json_response(conn, 200)
    end

    test "returns :bad_request with nonvalid params", %{conn: conn} do
      conn = get(conn, Routes.task_path(conn, :index), lat: "abc", long: "xyz")
      assert json_response(conn, 400)["errors"] == %{"detail" => "Bad Request"}
    end
  end

  describe "create task" do
    setup %{conn: conn} do
      %Token{value: manager_token_value} = insert(:token, role: :manager)

      {:ok, conn: put_req_header(conn, "authorization", "Bearer #{manager_token_value}")}
    end

    test "renders task when data is valid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task: @create_attrs)

      assert %{
               "id" => _,
               "state" => "new",
               "lat1" => 55.817566,
               "lat2" => 55.746081,
               "long1" => 37.491528,
               "long2" => 37.48773
             } = json_response(conn, 201)["data"]
    end

    test "driver can't create a task", %{conn: conn} do
      %Token{value: driver_token_value} = insert(:token, role: :driver)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{driver_token_value}")
        |> post(Routes.task_path(conn, :create), task: @invalid_attrs)

      assert json_response(conn, 401)["errors"] == %{"detail" => "Unauthorized"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.task_path(conn, :create), task: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update task" do
    setup %{conn: conn} do
      %Token{value: driver_token_value} = insert(:token, role: :driver)

      {:ok, conn: put_req_header(conn, "authorization", "Bearer #{driver_token_value}"), task: insert(:task)}
    end

    test "successfully picks a task", %{conn: conn, task: %Task{id: id} = task} do
      conn = patch(conn, Routes.task_path(conn, :pick, task))
      assert %{"id" => ^id, "state" => "assigned"} = json_response(conn, 200)["data"]
    end

    test "successfully finishes a task", %{conn: conn, task: %Task{id: id} = task} do
      conn = patch(conn, Routes.task_path(conn, :finish, task))
      assert %{"id" => ^id, "state" => "done"} = json_response(conn, 200)["data"]
    end

    test "manager can't pick a task", %{conn: conn, task: task} do
      %Token{value: manager_token_value} = insert(:token, role: :manager)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{manager_token_value}")
        |> patch(Routes.task_path(conn, :pick, task))

      assert json_response(conn, 401)["errors"] == %{"detail" => "Unauthorized"}
    end

    test "manager can't finish a task", %{conn: conn, task: task} do
      %Token{value: manager_token_value} = insert(:token, role: :manager)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{manager_token_value}")
        |> patch(Routes.task_path(conn, :finish, task))

      assert json_response(conn, 401)["errors"] == %{"detail" => "Unauthorized"}
    end
  end
end
