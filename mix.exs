defmodule DynamoBoilerplate.Mixfile do
  use Mix.Project

  def project do
    [ app: :dynamo_boilerplate,
      version: "0.0.1",
      dynamos: [DynamoBoilerplate.Dynamo],
      compilers: [:elixir, :dynamo, :app],
      env: [prod: [compile_path: "ebin"]],
      compile_path: "tmp/#{Mix.env}/dynamo_boilerplate/ebin",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [ applications: [:exlager, :cowboy, :dynamo],
      env: [
        eredis_pool: [
          default: [
            size: 10,
            max_overflow: 10,
            host: '127.0.0.1',
            port: 6379,
            database: 5,
            password: '',
            reconnect_sleep: 20
          ]
        ]
      ],
      mod: { DynamoBoilerplate, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :exlager, github: "khia/exlager" },
      { :eredis_pool, github: "hiroeorz/eredis_pool" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" } ]
  end
end
