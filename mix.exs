defmodule UeberauthPasswordless.MixProject do
  use Mix.Project

  def project do
    [
      app: :ueberauth_passwordless,
      version: "0.3.2",
      elixir: "~> 1.13.0",
      description: "Passwordless Strategy for Ueberauth using 'Magic Links'",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs(),
      name: "Ueberauth Passwordless",
      source_url: "https://github.com/studitemps/ueberauth_passwordless"
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ueberauth.Strategy.Passwordless.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ueberauth, "~> 0.6"},
      {:ex_crypto, github: "ntrepid8/ex_crypto", ref: "0915c274503f9fc6d6f5fab8c98467e7414cf8fc"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/studitemps/ueberauth_passwordless"}
    ]
  end

  defp docs do
    [extras: ["README.md"]]
  end
end
