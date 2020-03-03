defmodule Ueberauth.Strategy.Passwordless.Store do
  @moduledoc """
  The uses an :ets store to satisfy the requirement that a token can only be used once.
  """
  use GenServer

  @me __MODULE__

  @defaults [
    name: @me,
    table_name: :passwordless_token_store
  ]

  ## Client API

  def start_link(opts), do: GenServer.start_link(@me, opts, name: config(:name))

  def add(token), do: GenServer.cast(@me, {:add, token})

  def remove(token), do: GenServer.cast(@me, {:remove, token})

  def exists?(token) do
    case :ets.lookup(config(:table_name), token) do
      [] -> false
      [{_token}] -> true
    end
  end

  ## Server callbacks

  def handle_cast({:add, token}, init_args) do
    :ets.insert(config(:table_name), {token})
    {:noreply, init_args}
  end

  def handle_cast({:remove, token}, init_args) do
    :ets.delete(config(:table_name), token)
    {:noreply, init_args}
  end

  def init(init_args) do
    :ets.new(config(:table_name), [:set, :protected, :named_table])
    {:ok, init_args}
  end

  defp config(key), do: get_config() |> Keyword.fetch!(key)

  defp get_config() do
    config = Application.get_env(:ueberauth, __MODULE__, [])
    @defaults |> Keyword.merge(config)
  end
end
