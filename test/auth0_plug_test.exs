defmodule Auth0PlugTest do
  use ExUnit.Case
  doctest Auth0Plug

  test "greets the world" do
    assert Auth0Plug.hello() == :world
  end
end
