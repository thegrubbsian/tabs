defmodule Tabs do
  use Timex
  use Exredis

  def default_resolutions do
    [:year, :month, :day, :hour, :minute, :second]
  end

  def increment(name), do: increment(:all, name, Date.now, default_resolutions)
  def increment(bucket, name), do: increment(bucket, name, Date.now, default_resolutions)
  def increment(name, timestamp = %DateTime{}), do: increment(:all, name, timestamp, default_resolutions)
  def increment(bucket, name, timestamp = %DateTime{}), do: increment(bucket, name, timestamp, default_resolutions)
  def increment(name, resolutions) when is_list(resolutions), do: increment(:all, name, Date.now, resolutions)
  def increment(bucket, name, resolutions) when is_list(resolutions), do: increment(bucket, name, Date.now resolutions)

  def increment(bucket, name, timestamp, resolutions) do
    client = Exredis.start
    Enum.each(resolutions, fn(unit) ->
      key = storage_key(bucket, :counter, name, unit, timestamp)
      start |> query(["INCR", key])
    end)
  end

  def record(bucket, name, value, options) do
  end

  def stats(bucket, name, unit, starting, ending) do
  end

  def storage_key(bucket, metric_type, name, resolution, timestamp) do
    formatted_time = Resolution.serialize(resolution, timestamp)
    "stat:#{bucket}:#{metric_type}:#{name}:#{resolution}:#{formatted_time}"
  end

end
