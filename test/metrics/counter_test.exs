defmodule CounterTest do
  use ExUnit.Case
  use Timex
  alias Tabs.Metrics.Counter

  setup do
    client = Exredis.start
    on_exit fn -> Exredis.query(Exredis.start, ["FLUSHDB"]) end
    timestamp = Date.from({ {2014, 3, 17}, {3, 55, 29} })
    { :ok, client: client, timestamp: timestamp }
  end

  test "storage_key() generates the correct keys", %{ timestamp: timestamp } do
    assert Counter.storage_key(:foo, :bar, :minute, timestamp) == "stat:foo:counter:bar:minute:2014-03-17-03-55"
    assert Counter.storage_key(:baz, :boo, :day, timestamp) == "stat:baz:counter:boo:day:2014-03-17"
  end

  test "increment() sets the correct redis keys", %{ client: client, timestamp: timestamp } do
    Counter.increment(client, :foo, :bar, timestamp, Tabs.default_resolutions)
    Enum.each(Tabs.default_resolutions, fn(unit) ->
      assert Exredis.query(client, ["GET", Counter.storage_key(:all, :foo, unit, timestamp)]) != nil
    end)
  end

  test "increment() increments a counter as expected", %{ client: client, timestamp: timestamp } do
    Counter.increment(client, :all, :foo, timestamp, Tabs.default_resolutions)
    assert Exredis.query(client, ["GET", Counter.storage_key(:all, :foo, :minute, timestamp)]) == "1"

    Counter.increment(client, :foo, :bar, timestamp, Tabs.default_resolutions)
    assert Exredis.query(client, ["GET", Counter.storage_key(:all, :foo, :minute, timestamp)]) == "2"

    Counter.increment(client, :foo, :bar, timestamp, Tabs.default_resolutions)
    assert Exredis.query(client, ["GET", Counter.storage_key(:all, :foo, :minute, timestamp)]) == "3"
  end

end
