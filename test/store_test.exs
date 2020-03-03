defmodule UeberauthPasswordless.StoreTest do
  use ExUnit.Case, async: true

  alias Ueberauth.Strategy.Passwordless.Store

  test "with the default name is successful" do
    assert :ets.whereis(:passwordless_token_store)
  end

  describe "add/1" do
    test "is successful with a new token" do
      assert [] = :ets.lookup(:passwordless_token_store, "1")

      Store.add("1")

      assert [{"1", _datetime}] = :ets.lookup(:passwordless_token_store, "1")
    end

    test "is also successful if then token gets added again" do
      :ets.lookup(:passwordless_token_store, "2")

      assert :ok = Store.add("2")
      assert :ok = Store.add("2")

      assert [{"2", _datetime}] = :ets.lookup(:passwordless_token_store, "2")
    end
  end

  describe "remove/1" do
    test "removes an existing token" do
      Store.add("3")
      assert Store.exists?("3")

      Store.remove("3")

      refute Store.exists?("3")
    end

    test "is noop for non-existing token" do
      Store.add("4")
      assert Store.exists?("4")

      Store.remove("54321")

      assert Store.exists?("4")
    end
  end

  describe "exists?/1" do
    test "returns true if a token exists" do
      Store.add("5")

      assert Store.exists?("5")
    end

    test "returns false if a token does not exist" do
      refute Store.exists?("6")
    end
  end

  describe "collect_garbage" do
    test "removes outdated token" do
      Store.add("8", ~U[2020-01-01 00:00:00Z])
      assert Store.exists?("8")

      send(Store, :collect_garbage)
      :timer.sleep(100)

      refute Store.exists?("8")
    end

    test "does not affect still active token" do
      Store.add("8", DateTime.utc_now())
      assert Store.exists?("8")

      send(Store, :collect_garbage)
      :timer.sleep(100)

      assert Store.exists?("8")
    end
  end
end
