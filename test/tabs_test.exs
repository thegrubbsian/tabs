defmodule TabsTest do
  use ExUnit.Case
  use Timex

  setup do
    client = Exredis.start
    on_exit fn -> Exredis.query(Exredis.start, ["FLUSHDB"]) end
    timestamp = Date.from({ {2014, 3, 17}, {3, 55, 29} })
    { :ok, client: client, timestamp: timestamp }
  end

end
