defmodule Auth0.Auth.Authorize do
  @moduledoc """
  Plug for authorizing endpoints using Bearer authorization token.
  """
  @behaviour Plug

  import Plug.Conn
  alias Auth0.Auth.Token

  @spec init(any) :: any
  def init(default), do: default

  @doc """
  Extracts the Bearer token from the authorization header and verifies the claims.
  """
  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, _default) do
    with {:ok, token} when is_binary(token) <- get_token(conn),
         {:ok, _claims} <- Token.verify_and_validate(token) do
      conn
    else
      {:error, error} -> handle_error_response(conn, error)
    end
  end

  defp get_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      ["bearer " <> token] -> {:ok, token}
      [] -> {:error, :missing_token}
      ["Bearer"] -> {:error, :invalid_token}
      _ -> {:error, :invalid_token}
    end
  end

  defp handle_error_response(conn, error) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
         401,
         Jason.encode!(
           %{
             success: false,
             message: error,
           }
         )
       )
  end
end
