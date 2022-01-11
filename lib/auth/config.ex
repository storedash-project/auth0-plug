defmodule Auth0.Auth.Config do
  defp get_env, do: Application.get_env(:auth0_plug, :auth0, [])

  def audience, do: Keyword.get(get_env(), :audience)

  def base_url do
    auth0_domain = Keyword.get(get_env(), :domain)
    "https://#{auth0_domain}/"
  end
end
