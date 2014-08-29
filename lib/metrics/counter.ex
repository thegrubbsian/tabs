defmodule Tabs.Metrics.Counter do
  use Exredis
  alias Tabs.Resolution

  def increment(client, bucket, name, timestamp, resolutions) do
    Enum.each(resolutions, fn(unit) ->
      key = storage_key(bucket, name, unit, timestamp)
      client |> query(["INCR", key])
    end)
  end

  def storage_key(bucket, name, resolution, timestamp) do
    formatted_time = Resolution.serialize(resolution, timestamp)
    "stat:#{bucket}:counter:#{name}:#{resolution}:#{formatted_time}"
  end

end
