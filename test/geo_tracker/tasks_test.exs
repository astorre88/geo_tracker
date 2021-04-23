defmodule GeoTracker.TasksTest do
  use GeoTracker.DataCase

  import GeoTracker.Factory

  alias GeoTracker.Geo.Point
  alias GeoTracker.Tasks

  describe "tasks" do
    alias GeoTracker.Tasks.Task

    @valid_attrs %{
      pickup: Point.from_coordinates(55.817566, 37.491528),
      delivery: Point.from_coordinates(55.746081, 37.487730)
    }
    @invalid_attrs %{pickup: nil, delivery: nil}

    test "list_tasks/0 returns all tasks" do
      task = insert(:task)
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = insert(:task)
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok,
              %Task{
                state: :new,
                pickup: %Geo.Point{coordinates: {55.817566, 37.491528}},
                delivery: %Geo.Point{coordinates: {55.746081, 37.487730}}
              }} = Tasks.create_task(@valid_attrs)
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Tasks.create_task(@invalid_attrs)
      assert errors_on(changeset) == %{delivery: ["can't be blank"], pickup: ["can't be blank"]}
    end

    test "pick_task/2 picks the task" do
      %Task{id: id} = insert(:task)

      assert {:ok, %Task{state: :assigned}} = Tasks.pick_task(id)
    end

    test "finish_task/2 finishes the task" do
      %Task{id: id} = insert(:task)

      assert {:ok, %Task{state: :done}} = Tasks.finish_task(id)
    end
  end
end