defmodule DynamoBoilerplate.EredisPool do
  require Lager, as: Log

  @doc """
  Return a binary (string) version of our parameter.

  ## Examples

      iex> DynamoBoilerplate.EredisPool.set_strings_data('name', 'ryuone')
      {:ok, "OK"}
      iex> DynamoBoilerplate.EredisPool.get_strings_data('name')
      {:ok, "ryuone"}
  """
  def set_strings_data(key, value) when is_list(key) and is_list(value) do
    :eredis_pool.q({:global, :default}, ['set', key, value])
  end

  def get_strings_data(key) when is_list(key) do
    :eredis_pool.q({:global, :default}, ['get', key])
  end
end
