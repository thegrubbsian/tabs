defmodule ValueTest do
  use ExUnit.Case
  use Timex
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

end
