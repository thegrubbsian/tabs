defmodule ValueTest do
  use ExUnit.Case
  use Timex
  use Exredis
  use Jazz
  alias Tabs.Metrics.Value

  setup do
    client = Exredis.start
    on_exit fn -> Exredis.query(Exredis.start, ["FLUSHDB"]) end
    timestamp = Date.from({ {2014, 3, 17}, {3, 55, 29} })
    { :ok, client: client, timestamp: timestamp }
  end

  test "storage_key() generates the correct keys", %{ timestamp: timestamp } do
    assert Value.storage_key(:foo, :bar, :minute, timestamp) == "stat:foo:value:bar:minute:2014-03-17-03-55"
    assert Value.storage_key(:baz, :boo, :day, timestamp) == "stat:baz:value:boo:day:2014-03-17"
  end

  test "record() sets the correct keys in redis", %{ timestamp: timestamp, client: client } do
    Value.record(client, :foo, :bar, 42, timestamp, Tabs.default_resolutions)
    Enum.each(Tabs.default_resolutions, fn(unit) ->
      assert Exredis.query(client, ["GET", Value.storage_key(:all, :foo, unit, timestamp)]) != nil
    end)
  end

  test "record() correctly updates sum, count, and average", %{ timestamp: timestamp, client: client } do
    key = Value.storage_key(:foo, :bar, :hour, timestamp)
    Value.record(client, :foo, :bar, 42, timestamp, Tabs.default_resolutions)
    Value.record(client, :foo, :bar, 99.3, timestamp, Tabs.default_resolutions)
    Value.record(client, :foo, :bar, 18.54, timestamp, Tabs.default_resolutions)
    { :ok, data } = client |> query(["GET", key]) |> JSON.decode(keys: :atoms)
    assert data.count == 3
    assert data.sum == 159.84
    assert data.avg == 53.28
  end

  test "record() correctly sets the min, max, trail, and trend", %{ timestamp: timestamp, client: client } do
    key = Value.storage_key(:foo, :bar, :hour, timestamp)

    Value.record(client, :foo, :bar, 42, timestamp, Tabs.default_resolutions)
    { :ok, data } = client |> query(["GET", key]) |> JSON.decode(keys: :atoms)
    assert data.min == 42
    assert data.max == 42
    assert data.trail == [42]
    assert data.trend == "hold"

    Value.record(client, :foo, :bar, 99.3, timestamp, Tabs.default_resolutions)
    { :ok, data } = client |> query(["GET", key]) |> JSON.decode(keys: :atoms)
    assert data.min == 42
    assert data.max == 99.3
    assert data.trail == [99.3, 42]
    assert data.trend == "up"

    Value.record(client, :foo, :bar, 18.54, timestamp, Tabs.default_resolutions)
    { :ok, data } = client |> query(["GET", key]) |> JSON.decode(keys: :atoms)
    assert data.min == 18.54
    assert data.max == 99.3
    assert data.trail == [18.54, 99.3, 42]
    assert data.trend == "down"
  end

end
