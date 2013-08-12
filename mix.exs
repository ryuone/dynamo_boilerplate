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
      mod: { DynamoBoilerplate, [] } ]
  end

  defp deps do
    [ { :cowboy, github: "extend/cowboy" },
      { :exlager, github: "khia/exlager" },
      { :dynamo, "0.1.0-dev", github: "elixir-lang/dynamo" } ]
  end
end
