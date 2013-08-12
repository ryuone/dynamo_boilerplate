defmodule BasicAuthentication do
  require Lager, as: Log

  def basicAuth(conn) do
    conn = case conn.req_headers['authorization'] do
      nil ->
        setAuthenticate(conn)
      authdata ->
        case parseAuthData(authdata) |> checkIdPassword do
          true ->
            conn
          false ->
            setAuthenticate(conn)
        end
    end
    conn
  end

  defp parseAuthData(authdata) when is_binary(authdata) do
    ["Basic", base64data] = String.split(authdata, " ")
    base64data |> :base64.decode |> String.split(":")
  end

  defp checkIdPassword(authdata) do
    case authdata do
      ["ryuone", "ryuone"] ->
        true
      _ ->
        false
    end
  end

  defp setAuthenticate(conn) do
    conn = conn.put_resp_header('WWW-Authenticate', 'Basic realm="BasicTest"')
    conn.status(401)
  end
end
