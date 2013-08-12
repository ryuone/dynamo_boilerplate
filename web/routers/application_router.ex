defmodule ApplicationRouter do
  use Dynamo.Router
  require Lager, as: Log

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params, :session])
  end

  # It is common to break your Dynamo in many
  # routers forwarding the requests between them
  # forward "/posts", to: PostsRouter

  get "/" do
    Log.info("path : ~p", [conn.path])
    conn = conn.assign(:title, "Welcome to Dynamo!")
    render conn, "index.html"
  end

  @doc """
  For cookie
  """
  get "/put_cookie" do
    conn = put_cookie(conn, :foo, :new, path: "/")
    conn.send(200, "<h1>OK /put_cookie</h1>")
  end

  get "/get_cookie" do
    conn.send(200, "<h1>OK /get_cookie : #{get_cookie(conn, "foo")}</h1>")
  end

  @doc """
  For session
  """
  get "/put_session" do
    put_session(conn, :hello, "world").send(200, "<h1>OK</h1>")
  end

  get "/get_session" do
    conn.send(200, "<h1>#{get_session(conn, :hello)}</h1>")
  end

  @doc """
  For eredis_pool
  """
  get "/set_strings_data" do
    DynamoBoilerplate.EredisPool.set_strings_data('name', 'ryuone')
    conn.send(200, "<h1>OK /set_strings_data</h1>")
  end

  get "/get_strings_data" do
    {ok, data} = DynamoBoilerplate.EredisPool.get_strings_data('name')
    conn.send(200, "<h1>OK /get_strings_data : #{data}</h1>")
  end
end
