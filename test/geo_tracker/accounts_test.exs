defmodule GeoTracker.AccountsTest do
  use GeoTracker.DataCase

  import GeoTracker.Factory

  alias GeoTracker.Accounts
  alias GeoTracker.Accounts.Token

  describe "tokens" do
    test "get_token_by_value/1 returns the token with given value" do
      %Token{value: token_value} = insert(:token, role: :driver)
      assert %Token{role: :driver} = Accounts.get_token_by_value(token_value)
    end
  end
end
