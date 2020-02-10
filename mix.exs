defmodule UeberauthPasswordless.MixProject do
  use Mix.Project

  def project do
    [
      app: :ueberauth_passwordless,
      version: "0.1.0",
      elixir: "~> 1.9",
      description: "Passwordless Strategy for Ueberauth using 'Magic Links'",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "Ueberauth Passwordless",
      source_url: "https://github.com/studitemps/ueberauth_passwordless"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ueberauth, "~> 0.6"},
      {:ex_crypto, "~> 0.10.0"}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/studitemps/ueberauth_passwordless"}
    ]
  end
end
