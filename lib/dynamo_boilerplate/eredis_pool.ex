defmodule DynamoBoilerplate.EredisPool do
  require Lager, as: Log

  def set_strings_data(key, value) when is_list(key) and is_list(value) do
    :eredis_pool.q({:global, :default}, ['set', key, value])
  end

  def get_strings_data(key) when is_list(key) do
    r = :eredis_pool.q({:global, :default}, ['get', key])
    Log.info("get_strings_data result : ~p", [r])
    r
  end
end
