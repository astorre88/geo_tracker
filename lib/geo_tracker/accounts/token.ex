import EctoEnum, only: [defenum: 2]
defenum(GeoTracker.RoleEnum, manager: 0, driver: 1)

defmodule GeoTracker.Accounts.Token do
  use Ecto.Schema

  import Ecto.Changeset

  alias GeoTracker.RoleEnum

  @required_attrs ~w(value role)a
  @optional_attrs ~w()a

  schema "tokens" do
    field :role, RoleEnum, read_after_writes: true
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, @optional_attrs ++ @required_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:value)
  end
end
