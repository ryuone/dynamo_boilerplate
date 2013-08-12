Dynamo.under_test(DynamoBoilerplate.Dynamo)
Dynamo.Loader.enable
ExUnit.start

defmodule DynamoBoilerplate.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
