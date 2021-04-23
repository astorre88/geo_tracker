defmodule GeoTracker.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias GeoTracker.Repo

  alias GeoTracker.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Picks a task.

  ## Examples

      iex> pick_task(123)
      {:ok, %Task{}}

      iex> pick_task(456)
      {:error, %Ecto.Changeset{}}

  """
  def pick_task(id) do
    id
    |> get_task!()
    |> Task.changeset(%{state: :assigned})
    |> Repo.update()
  end

  @doc """
  Finishes a task.

  ## Examples

      iex> finish_task(123)
      {:ok, %Task{}}

      iex> finish_task(456)
      {:error, %Ecto.Changeset{}}

  """
  def finish_task(id) do
    id
    |> get_task!()
    |> Task.changeset(%{state: :done})
    |> Repo.update()
  end
end
