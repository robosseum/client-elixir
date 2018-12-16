defmodule RobosseumClientTest do
  use ExUnit.Case
  doctest RobosseumClient

  test "greets the world" do
    assert RobosseumClient.hello() == :world
  end
end
