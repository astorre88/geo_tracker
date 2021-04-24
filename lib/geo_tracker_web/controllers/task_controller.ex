defmodule GeoTrackerWeb.TaskController do
  use GeoTrackerWeb, :controller

  alias GeoTracker.Tasks
  alias GeoTracker.Tasks.Task

  action_fallback GeoTrackerWeb.FallbackController

  def index(conn, params) do
    with {:ok, tasks} <- Tasks.list_tasks(params) do
      render(conn, "index.json", tasks: tasks)
    end
  end

  def create(conn, %{"task" => task_params}) do
    with {:ok, %Task{} = task} <- Tasks.create_task(task_params) do
      conn
      |> put_status(:created)
      |> render("show.json", task: task)
    end
  end

  def pick(conn, %{"id" => id}) do
    with {:ok, %Task{} = task} <- Tasks.pick_task(id) do
      render(conn, "show.json", task: task)
    end
  end

  def finish(conn, %{"id" => id}) do
    with {:ok, %Task{} = task} <- Tasks.finish_task(id) do
      render(conn, "show.json", task: task)
    end
  end
end
