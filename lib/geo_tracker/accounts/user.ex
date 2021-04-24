defmodule GeoTracker.Accounts.User do
  use Ecto.Schema

  schema "users" do
    field :token, :string

    timestamps()
  end
end
