defmodule UeberauthPasswordless.StoreTest do
  use ExUnit.Case, async: true

  alias Ueberauth.Strategy.Passwordless.Store

  describe "starting the Store" do
    test "with the default name is successful" do
      {:ok, _pid} = GenServer.start_link(Store, [])
      assert GenServer.whereis(Store)
    end

    test "with a custom name is successful" do
      {:ok, _pid} = GenServer.start_link(Store, [], name: :test_module)
      assert GenServer.whereis(:test_module)
    end
  end

  describe "creating a new store" do
    test "with the default name is successful" do
      {:ok, _pid} = GenServer.start_link(Store, [])
      assert :ets.whereis(:passwordless_token_store)
    end

    test "with a custom name is successful" do
      {:ok, _pid} = GenServer.start_link(Store, table_name: :test_store)
      assert :ets.whereis(:test_store)
    end
  end

  describe "inserting a token" do
    test "is successful if the token does not exist yet" do
    end

    test "fails if the token exists already" do
    end
  end

  describe "validating a token" do
    test "is successful if the token exists" do
    end

    test "fails if the token does not exist" do
    end
  end
end
