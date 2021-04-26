defmodule GeoTracker.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias GeoTracker.Accounts
  alias GeoTracker.Accounts.Token
  alias GeoTrackerWeb.ErrorView

  def init(opts), do: opts

  def call(conn, _opts) do
    conn
    |> get_token()
    |> fetch_role(conn)
  end

  def generate_token(), do: :crypto.strong_rand_bytes(10) |> Base.encode16()

  def driver(conn = %{assigns: %{role: :driver}}, _), do: conn

  def driver(conn, _), do: halt_unauthorized(conn)

  def manager(conn = %{assigns: %{role: :manager}}, _), do: conn

  def manager(conn, _), do: halt_unauthorized(conn)

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> token
      _ -> nil
    end
  end

  defp fetch_role(token, conn) when is_binary(token) do
    case Accounts.get_token_by_value(token) do
      %Token{role: role} -> assign(conn, :role, role)
      _ -> assign(conn, :role, nil)
    end
  end

  defp fetch_role(_, conn) do
    assign(conn, :role, nil)
  end

  defp halt_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render(:"401")
    |> halt()
  end
end
