defmodule Auth0.Auth.Token do
  @moduledoc """
  Customizes the Joken config to verify and validate claims.
  """
  use Joken.Config, default_signer: nil

  alias Auth0.Auth.{Config, Strategy}

  add_hook(JokenJwks, strategy: Strategy)

  @impl true
  def token_config do
    default_claims(skip: [:aud, :iss])
    |> add_claim("iss", nil, &(&1 == iss()))
    |> add_claim("aud", nil, &(verify_audience/1))
  end

  defp verify_audience(audience) when is_binary(audience) do
    aud() == audience
  end

  defp verify_audience(audience) when is_list(audience) do
    aud() in audience
  end

  defp iss(), do: Config.base_url()
  defp aud(), do: Config.audience()
end
