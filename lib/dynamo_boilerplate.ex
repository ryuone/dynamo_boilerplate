defmodule DynamoBoilerplate do
  use Application.Behaviour
  require Lager, as: Log

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    Log.info "Start argument : ~p / ~p", [_type, _args]
    start_eredis_pool
    DynamoBoilerplate.Dynamo.start_link([max_restarts: 5, max_seconds: 5])
  end

  def start_eredis_pool do
    {:ok, pool_setting} = :application.get_env(:dynamo_boilerplate, :eredis_pool)
    :application.set_env(:eredis_pool, :pools, pool_setting)
    :application.start(:eredis_pool)
  end
end
