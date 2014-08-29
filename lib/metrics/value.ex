defmodule Tabs.Metrics.Value do
  use Exredis
  alias Tabs.Resolution

  def record(bucket, name, value, timestamp, resolutions) do
    client = Exredis.start
    Enum.each(resolutions, fn(unit) ->
    end)
  end

  def storage_key(bucket, name, resolution, timestamp) do
    formatted_time = Resolution.serialize(resolution, timestamp)
    "stat:#{bucket}:value:#{name}:#{resolution}:#{formatted_time}"
  end

end
