defmodule ApplicationRouter do
  use Dynamo.Router

  prepare do
    # Pick which parts of the request you want to fetch
    # You can comment the line below if you don't need
    # any of them or move them to a forwarded router
    conn.fetch([:cookies, :params])
  end

  # It is common to break your Dynamo in many
  # routers forwarding the requests between them
  # forward "/posts", to: PostsRouter

  get "/" do
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
end
