defmodule Ueberauth.Strategy.Passwordless.Application do
  use Application

  alias Ueberauth.Strategy.Passwordless

  def start(_type, opts) do
    if Passwordless.config(:use_store), do: start_store(opts)
  end

  defp start_store(opts) do
    children = [
      {Ueberauth.Strategy.Passwordless.Store, opts}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
