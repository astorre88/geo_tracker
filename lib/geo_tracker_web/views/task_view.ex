defmodule GeoTrackerWeb.TaskView do
  use GeoTrackerWeb, :view

  alias GeoTrackerWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id, state: task.state, pickup: task.pickup, delivery: task.delivery}
  end
end
