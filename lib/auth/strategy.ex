defmodule Auth0.Auth.Strategy do
  @moduledoc """
  Defines a custom Strategy for JokenJwks using a custom jwks domain.
  """
  use JokenJwks.DefaultStrategyTemplate
  alias Auth0.Auth.Config

  def init_opts(opts) do
    Keyword.merge(opts, jwks_url: jwks_url())
  end

  defp jwks_url do
    auth0_domain() <> ".well-known/jwks.json"
  end

  defp auth0_domain do
    Config.base_url()
  end
end
