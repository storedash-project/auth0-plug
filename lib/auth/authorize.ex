defmodule Auth0.Auth.Authorize do
  @moduledoc """
  Plug for authorizing endpoints using Bearer authorization token.
  """
  @behaviour Plug

  defmodule Auth0PlugError do
    @moduledoc """
    Error raised when inserting to the database.
    """

    defexception message: "An error occurred in Auth0 Plug", plug_status: 401
  end

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

  # Handle atom case.
  defp handle_error_response(_conn, error) when is_atom(error) do
    raise Auth0.Auth.Authorize.Auth0PlugError, message: Atom.to_string(error)
  end

  # Handle list case.
  defp handle_error_response(_conn, error) when is_list(error) do
    raise Auth0.Auth.Authorize.Auth0PlugError, message: error[:message]
  end

  # Handle the generic case
  defp handle_error_response(_conn, _error) do
    raise Auth0.Auth.Authorize.Auth0PlugError
  end
end
