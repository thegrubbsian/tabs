defmodule Tabs do
  use Timex
  use Jazz
  alias Tabs.Resolution
  alias Tabs.Metrics.Counter
  alias Tabs.Metrics.Value

  def default_resolutions do
    [:year, :month, :day, :hour, :minute, :second]
  end

  def increment_counter(name) do
    Counter.increment(:all, name, Date.now, default_resolutions)
  end

  def increment_counter(name, timestamp = %DateTime{}) do
    Counter.increment(:all, name, timestamp, default_resolutions)
  end

  def increment_counter(bucket, name) do
    Counter.increment(bucket, name, Date.now, default_resolutions)
  end

  def increment_counter(bucket, name, resolutions) when is_list(resolutions) do
    Counter.increment(bucket, name, Date.now, resolutions)
  end

  def increment_counter(bucket, name, timestamp = %DateTime{}) do
    Counter.increment(bucket, name, timestamp, default_resolutions)
  end

  def increment_counter(name, resolutions) when is_list(resolutions) do
    Counter.increment(:all, name, Date.now, resolutions)
  end

  def record_value(name, value) when is_number(value) do
    Value.record(:all, name, value, Date.now, default_resolutions)
  end

  def record_value(name, value, timestamp = %DateTime{}) when is_number(value) do
    Value.record(:all, name, value, timestamp, default_resolutions)
  end

  def record_value(name, value, resolutions) when is_list(resolutions) and is_number(value) do
    Value.record(:all, name, value, Date.now, resolutions)
  end

  def record_value(name, value, timestamp = %DateTime{}, resolutions) when is_list(resolutions) and is_number(value) do
    Value.record(:all, name, value, timestamp, default_resolutions)
  end

  def record_value(bucket, name, value) when is_number(value) do
    Value.record(bucket, name, value, Date.now, default_resolutions)
  end

  def record_value(bucket, name, value, timestamp = %DateTime{}) when is_number(value) do
    Value.record(bucket, name, value, timestamp, default_resolutions)
  end

  def record_value(bucket, name, value, resolutions) when is_number(value) and is_list(resolutions) do
    Value.record(bucket, name, value, Date.now, resolutions)
  end

  def record_value(bucket, name, value, timestamp = %DateTime{}, resolutions) when is_number(value) and is_list(resolutions) do
    Value.record(bucket, name, value, Date.now, resolutions)
  end

  def counter_stats(bucket, name, unit, starting, ending) do
  end

  def value_stats(bucket, name, unit, starting, ending) do
  end

end
