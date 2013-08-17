# Feature tests goes through the Dynamo.under_test
# and are meant to test the full stack.
defmodule HomeTest do
  use DynamoBoilerplate.TestCase, async: true
  use Dynamo.HTTP.Case
  require Lager, as: Log

  doctest DynamoBoilerplate.EredisPool

  test "returns OK" do
    conn = get("/?name=ryuone")
    conn = conn.put_req_header "authorization", "Basic cnl1b25lOnJ5dW9uZQ=="
    conn = get(conn, "/?name=ryuone")

    assert conn.sent_body =~ %r{Welcome to Dynamo!\(ryuone\)}
    assert conn.status == 200
  end
end
