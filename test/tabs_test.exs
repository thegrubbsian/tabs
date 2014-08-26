defmodule TabsTest do
  use ExUnit.Case
  use Timex

  setup do
    client = Exredis.start
    on_exit fn -> Exredis.query(Exredis.start, ["FLUSHDB"]) end
    timestamp = Date.from({ {2014, 3, 17}, {3, 55, 29} })
    { :ok, client: client, timestamp: timestamp }
  end

  test "storage_key() generates the correct keys", %{ timestamp: timestamp } do
    assert Tabs.storage_key(:foo, :counter, :bar, :minute, timestamp) == "stat:foo:counter:bar:minute:2014-03-17-03-55"
    assert Tabs.storage_key(:foo, :value, :bar, :second, timestamp) == "stat:foo:value:bar:second:2014-03-17-03-55-29"
  end

  test "increment() sets the correct redis keys", %{ client: client, timestamp: timestamp } do
    Tabs.increment(:foo, :bar, timestamp)
    Enum.each(Tabs.default_resolutions, fn(unit) ->
      assert Exredis.query(client, ["GET", Tabs.storage_key(:foo, :counter, :bar, unit, timestamp)]) != nil
    end)
  end

end
