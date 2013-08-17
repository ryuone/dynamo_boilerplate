defmodule ApplicationRouterTest do
  use DynamoBoilerplate.TestCase, async: true
  use Dynamo.HTTP.Case
  require Lager, as: Log

  # Sometimes it may be convenient to test a specific
  # aspect of a router in isolation. For such, we just
  # need to set the @endpoint to the router under test.
  @endpoint ApplicationRouter

  test "'/' : returns 200" do
    conn = conn(:GET, "/")
    conn = conn.put_req_header "authorization", "Basic cnl1b25lOnJ5dW9uZQ=="
    conn = get(conn, "/")

    assert conn.status == 200
    assert conn.fetch(:headers).resp_body =~ %r(Welcome)
    assert conn.resp_body =~ %r(Welcome)
  end

  test "'/' : returns 401" do
    assert {:halt!, conn} = catch_throw(get("/"))
    assert conn.status == 401
  end

  test "'/put_cookie' : return 200 and get data from cookie" do
    conn = get("/put_cookie")
    assert { "foo", "new", opts } = List.keyfind(conn.resp_cookies, "foo", 0)
    assert opts[:path] == "/"
    assert conn.status == 200
  end

  test "'/get_cookie' : return 200 and get from http" do
    conn = get("/get_cookie")
    assert conn.status == 200
    refute conn.sent_body =~ %r(new)

    conn = get(conn, "/put_cookie")
    conn = get(conn, "/get_cookie")
    assert conn.status == 200
    assert conn.sent_body =~ %r(new)
  end

  test "'/put_session' : return 200 and get session key" do
    conn = get("/put_session")
    assert { "_dynamo_boilerplate_session", _, opts } = List.keyfind(conn.resp_cookies, "_dynamo_boilerplate_session", 0)
    assert opts[:key] == "_dynamo_boilerplate_session"
    assert conn.status == 200
  end

  test "'/get_session' : return 200 and get session data" do
    conn = get("/put_session")
    conn = get(conn, "/get_session")
    assert conn.sent_body =~ %r(world)
    assert conn.status == 200
  end

  test "'/set_strings_data' : return 200" do
    conn = get("/set_strings_data")
    assert conn.sent_body =~ %r(set_strings_data)
    assert conn.status == 200
  end

  test "'/get_strings_data' : return 200 and get string data" do
    conn = get("/set_strings_data")
    conn = get(conn, "/get_strings_data")
    assert conn.sent_body =~ %r(ryuone)
    assert conn.status == 200
  end

  test "'/favicon.ico' : return 200" do
    conn = get("/favicon.ico")
    assert conn.resp_content_type == "image/x-icon"
    assert conn.status == 200
  end

  test "'/notfound?path=notfound_directory' : return 404" do
    conn = get("/notfound?path=notfound_directory")
    assert conn.resp_body =~ %r(Not implement : notfound_directory)
    assert conn.status == 404
  end

  test "'/notfound_redirect' : return 302" do
    conn = get("/notfound_redirect")
    assert conn.status == 302
  end

end
