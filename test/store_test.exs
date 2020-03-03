defmodule UeberauthPasswordless.StoreTest do
  use ExUnit.Case, async: true

  alias Ueberauth.Strategy.Passwordless.Store

  test "with the default name is successful" do
    assert :ets.whereis(:passwordless_token_store)
  end

  describe "add/1" do
    test "is successful with a new token" do
      assert [] = :ets.lookup(:passwordless_token_store, "12345")

      assert :ok = Store.add("12345")
      :timer.sleep(5)

      assert [{"12345"}] = :ets.lookup(:passwordless_token_store, "12345")
    end

    test "is also successful if then token gets added again" do
      :ets.lookup(:passwordless_token_store, "12345")

      assert :ok = Store.add("12345")
      assert :ok = Store.add("12345")
      :timer.sleep(1)

      assert [{"12345"}] = :ets.lookup(:passwordless_token_store, "12345")
    end
  end

  describe "remove/1" do
    test "removes an existing token" do
      Store.add("12345")
      :timer.sleep(1)
      assert Store.exists?("12345")

      Store.remove("12345")
      :timer.sleep(1)

      refute Store.exists?("12345")
    end
  end

  describe "exists?/1" do
    test "returns true if a token exists" do
      Store.add("12345")
      :timer.sleep(1)

      assert Store.exists?("12345")
    end

    test "returns false if a token does not exist" do
      refute Store.exists?("12345")
    end
  end
end
