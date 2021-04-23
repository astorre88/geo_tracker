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
    @update_attrs %{
      state: :assigned,
      pickup: Point.from_coordinates(55.746081, 37.487730),
      delivery: Point.from_coordinates(55.817566, 37.491528)
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
                state: 0,
                pickup: %Geo.Point{coordinates: {55.817566, 37.491528}},
                delivery: %Geo.Point{coordinates: {55.746081, 37.487730}}
              }} = Tasks.create_task(@valid_attrs)
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Tasks.create_task(@invalid_attrs)
      assert errors_on(changeset) == %{delivery: ["can't be blank"], pickup: ["can't be blank"]}
    end

    test "update_task/2 with valid data updates the task" do
      task = insert(:task)

      assert {:ok,
              %Task{
                state: :assigned,
                pickup: %Geo.Point{coordinates: {55.746081, 37.487730}},
                delivery: %Geo.Point{coordinates: {55.817566, 37.491528}}
              }} = Tasks.update_task(task, @update_attrs)
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = insert(:task)
      assert {:error, %Ecto.Changeset{} = changeset} = Tasks.update_task(task, @invalid_attrs)
      assert errors_on(changeset) == %{delivery: ["can't be blank"], pickup: ["can't be blank"]}
    end
  end
end
