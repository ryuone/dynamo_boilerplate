defmodule ApplicationRouter do
  use Dynamo.Router
  require Lager, as: Log
  require BasicAuthentication

  filter Dynamo.Filters.Session.new(
    Dynamo.Filters.Session.CookieStore,
    [
      key: "_dynamo_boilerplate_session",
      secret: "RoaFKJVEwvckED8FtQuAuwwkh8ciXzA72zUYw3HPLfpoqkSWspfYHV2OPPiIobU/"])

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params, :headers])
  end

  # It is common to break your Dynamo in many
  # routers forwarding the requests between them
  # forward "/posts", to: PostsRouter

  @prepare :basicAuth
  get "/" do
    conn = conn.assign(:title, "Welcome to Dynamo!")
    conn = conn.assign(:name, conn.params[:name])
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
    conn = conn.fetch :session
    put_session(conn, :hello, "world").send(200, "<h1>OK</h1>")
  end

  get "/get_session" do
    conn = conn.fetch :session
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
    {:ok, data} = DynamoBoilerplate.EredisPool.get_strings_data('name')
    conn.send(200, "<h1>OK /get_strings_data : #{data}</h1>")
  end

  get "/favicon.ico" do
    {:ok, fd} = :file.read_file(DynamoBoilerplate.Dynamo.config[:dynamo][:static_root] <> "/favicon.ico")
    conn = conn.resp_content_type("image/x-icon")
    conn.send(200, fd)
  end

  @doc """
  Notfound page
  """
  get "/notfound" do
    conn.resp 404, "<h1>Not implement : #{conn.params[:path]}</h1>"
  end

  @doc """
  Not implement
  """
  get "/:notimplement" do
    redirect conn, to: "/notfound?path=#{notimplement}"
  end

  defp basicAuth(conn) do
    BasicAuthentication.basicAuth(conn)
  end
end
