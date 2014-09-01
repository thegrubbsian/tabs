defmodule Tabs.Metrics.Value do
  use Timex
  use Exredis
  use Jazz
  alias Tabs.Resolution

  def record(client, bucket, name, value, timestamp = %DateTime{}, resolutions) when is_number(value) do
    Enum.each(resolutions, fn(unit) ->
      key = storage_key(bucket, name, unit, timestamp)
      { :ok, current } = case client |> query(["GET", key]) do
        :undefined -> { :ok, default_data }
        value -> JSON.decode(value, keys: :atoms)
      end
      { :ok, updated } = new_data(current, value) |> JSON.encode
      client |> query(["SET", key, updated])
    end)
  end

  def storage_key(bucket, name, resolution, timestamp) do
    formatted_time = Resolution.serialize(resolution, timestamp)
    "stat:#{bucket}:value:#{name}:#{resolution}:#{formatted_time}"
  end

  defp default_data do
    %{ count: 0, sum: 0.00, min: nil, max: nil, avg: 0.00, trail: [], trend: "hold" }
  end

  defp new_data(current, value) do
    %{ current |
      count: updated_count(current),
      sum: updated_sum(current, value),
      min: updated_min(current, value),
      max: updated_max(current, value),
      avg: updated_avg(current, value),
      trail: updated_trail(current, value),
      trend: updated_trend(current, value)
    }
  end

  defp updated_count(%{ count: count }), do: count + 1
  defp updated_avg(%{ sum: sum, count: count }, value), do: (sum + value) / (count + 1)
  defp updated_sum(%{ sum: sum }, value), do: sum + value
  defp updated_trail(%{ trail: trail }, value), do: [value] ++ List.delete_at(trail, 19)

  defp updated_min(%{ min: min }, value) do
    cond do
      min == nil -> value
      min >= value -> value
      min < value -> min
    end
  end

  defp updated_max(%{ max: max }, value) do
    cond do
      max == nil -> value
      max <= value -> value
      max > value -> max
    end
  end

  defp updated_trend(%{ trail: [] }, value), do: "hold"

  defp updated_trend(%{ trail: [prev|_] }, value) do
    cond do
      prev == value -> "hold"
      prev < value -> "up"
      prev > value -> "down"
    end
  end

end
