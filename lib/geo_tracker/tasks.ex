defmodule GeoTracker.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false

  alias GeoTracker.Geo.Point
  alias GeoTracker.Repo
  alias GeoTracker.Tasks.Task
  alias GeoTracker.Tasks.Queries.Task, as: TaskQuery

  @doc """
  Returns the ordered by distance list of tasks.

  ## Examples

      iex> list_tasks(params)
      {:ok, [%Task{}, ...]}

      iex> list_tasks(bad_params)
      {:error, :bad_request}

  """
  def list_tasks(%{"lat" => lat, "lon" => lon}) do
    with {:ok, parsed_lat} <- parse_from(lat),
         {:ok, parsed_lon} <- parse_from(lon) do
      {:ok,
       Task
       |> TaskQuery.by_distance(Point.from_coordinates(parsed_lat, parsed_lon))
       |> Repo.all()}
    end
  end

  defp parse_from(value) when is_binary(value) do
    case Float.parse(value) do
      {parsed, _} -> {:ok, parsed}
      _ -> {:error, :bad_request}
    end
  end

  defp parse_from(value) when is_number(value), do: {:ok, value}
  defp parse_from(_), do: {:error, :bad_request}

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
