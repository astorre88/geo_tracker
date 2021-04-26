defmodule GeoTracker.Accounts do
  alias GeoTracker.Accounts.Token
  alias GeoTracker.Repo

  @doc """
  Gets a single token.

  ## Examples

      iex> get_token_by_value(123)
      %Token{}

      iex> get_token_by_value(456)
      nil

  """
  def get_token_by_value(value) do
    Repo.get_by(Token, value: value)
  end
end
