defmodule Ueberauth.Strategy.Passwordless.Store do
  @moduledoc """
  The uses an :ets store to satisfy the requirement that a token can only be used once.
  """
  use GenServer

  alias Ueberauth.Strategy.Passwordless

  @me __MODULE__

  @defaults [
    name: @me,
    table_name: :passwordless_token_store,
    # Every Minute
    garbage_collection_interval: 1000 * 60
  ]

  ## Client API

  def start_link(opts), do: GenServer.start_link(@me, opts, name: config(:name))

  def add(token, timestamp \\ DateTime.utc_now()),
    do: GenServer.call(@me, {:add, token, timestamp})

  def remove(token), do: GenServer.call(@me, {:remove, token})

  def exists?(token), do: :ets.member(config(:table_name), token)

  ## Server callbacks

  def handle_call({:add, token, timestamp}, _from, init_args) do
    :ets.insert(config(:table_name), {token, timestamp})
    {:reply, :ok, init_args}
  end

  def handle_call({:remove, token}, _from, init_args) do
    :ets.delete(config(:table_name), token)
    {:reply, :ok, init_args}
  end

  def init(init_args) do
    create_table()
    schedule_garbage_collection()
    {:ok, init_args}
  end

  defp create_table(), do: :ets.new(config(:table_name), [:set, :protected, :named_table])

  defp schedule_garbage_collection(),
    do: Process.send_after(self(), :collect_garbage, config(:garbage_collection_interval))

  def handle_info(:collect_garbage, init_args) do
    now = DateTime.utc_now()
    ttl = Passwordless.config(:ttl)

    :ets.tab2list(config(:table_name))
    |> Enum.each(fn {token, timestamp} ->
      diff = DateTime.diff(now, timestamp)

      if diff >= ttl, do: :ets.delete(config(:table_name), token)
    end)

    schedule_garbage_collection()

    {:noreply, init_args}
  end

  defp config(key), do: get_config() |> Keyword.fetch!(key)

  defp get_config() do
    config = Application.get_env(:ueberauth, __MODULE__, [])
    @defaults |> Keyword.merge(config)
  end
end
