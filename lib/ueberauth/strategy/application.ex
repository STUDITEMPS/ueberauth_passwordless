defmodule Ueberauth.Strategy.Passwordless.Application do
  use Application

  alias Ueberauth.Strategy.Passwordless

  def start(_type, opts) do
    :use_store
    |> Passwordless.config()
    |> maybe_start_store(opts)
  end

  defp maybe_start_store(true, opts) do
    children = [
      {Ueberauth.Strategy.Passwordless.Store, opts}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp maybe_start_store(false, _opts) do
    {:ok, self()}
  end
end
