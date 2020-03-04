defmodule Ueberauth.Strategy.Passwordless.Application do
  use Application

  def start(_type, opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)

    children = [
      {Ueberauth.Strategy.Passwordless.Store, opts}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
