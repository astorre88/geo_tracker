defmodule GeoTrackerWeb.TaskView do
  use GeoTrackerWeb, :view

  alias GeoTrackerWeb.TaskView

  def render("index.json", %{tasks: tasks}) do
    %{
      data: render_many(tasks, TaskView, "task.json"),
      pagination: %{
        page_number: tasks.page_number,
        page_size: tasks.page_size,
        total_pages: tasks.total_pages,
        total_entries: tasks.total_entries
      }
    }
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    {lat1, long1} = task.pickup.coordinates
    {lat2, long2} = task.delivery.coordinates
    %{id: task.id, state: task.state, lat1: lat1, long1: long1, lat2: lat2, long2: long2}
  end
end
