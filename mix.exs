defmodule ElixirDockerBBuilder.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_docker_builder,
      version: "0.1.0",
      elixir: "~> 1.14",
      release_date: ~D[2023-02-16],
      compilers: [:domo_compiler] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [
      {:phoenix, "~> 1.7.1", override: true},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:ecto_erd, "~> 0.5.0", only: :dev},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:acx, git: "https://github.com/casbin/casbin-ex"},
      {:jason, "~> 1.2"},
      {:faker, "~> 0.17"},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:junit_formatter, "~> 3.3", only: :test},
      {:plug_cowboy, "~> 2.5"},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:canary, "~> 1.1.1"},
      {:money, "~> 1.12"},
      {:mix_audit, "~> 2.0", only: [:dev, :test], runtime: false},
      {:oban, "~> 2.14.2"},
      {:joken, "~> 2.6"},
      {:paper_trail, "~> 1.0.0"},
      {:tesla, "~> 1.5"},
      {:hackney, "~> 1.10"},
      {:domo, "~> 1.5"},
      {:polymorphic_embed, "~> 3.0.5"},
      {:ymlr, "~> 2.0"},
      {:ex_open_api_utils, "~> 0.5.2"},
      {:sobelow, "~> 0.12", only: [:dev, :test], runtime: false},
      {:typed_struct, "~> 0.3.0"},
      {:lcov_ex, "~> 0.3", only: [:dev, :test], runtime: false},
      {:mox, "~> 1.0", only: :test},
      {:timex, "~> 3.7"}
    ]
  end
end
