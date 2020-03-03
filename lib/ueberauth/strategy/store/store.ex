defmodule Ueberauth.Strategy.Passwordless.Store do
  @moduledoc """
  The uses an :ets store to satisfy the requirement that a token can only be used once.
  """
  use GenServer

  @me __MODULE__

  def start_link(opts) do
    create_table(opts)

    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(@me, opts, name: name)
  end

  def add(token), do: GenServer.cast(@me, {:add, token})

  def handle_cast({:add, token}, opts) do
    table_name(opts)
    |> :ets.lookup(token)
    |> case do
      [] ->
        :ets.insert(table_name(opts), {token})
        {:noreply, :ok}

      [_token] ->
        {:noreply, :error}
    end
  end

  defp create_table(opts) do
    :ets.new(table_name(opts), [:set, :protected])
  end

  defp table_name(opts), do: Keyword.get(opts, :table_name, :passwordless_token_store)

  def init(opts), do: {:ok, opts}
end
