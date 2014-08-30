defmodule Tabs.Resolution do
  use Timex

  def serialize(:year, value), do: DateFormat.format!(value, "%Y", :strftime)
  def serialize(:month, value), do: DateFormat.format!(value, "%Y-%m", :strftime)
  def serialize(:day, value), do: DateFormat.format!(value, "%Y-%m-%d", :strftime)
  def serialize(:hour, value), do: DateFormat.format!(value, "%Y-%m-%d-%H", :strftime)
  def serialize(:minute, value), do: DateFormat.format!(value, "%Y-%m-%d-%H-%M", :strftime)
  def serialize(:second, value), do: DateFormat.format!(value, "%Y-%m-%d-%H-%M-%S", :strftime)

  def deserialize(:year, value), do: parse_and_normalize(:year, value, "%Y")
  def deserialize(:month, value), do: parse_and_normalize(:month, value, "%Y-%m")
  def deserialize(:day, value), do: parse_and_normalize(:day, value, "%Y-%m-%d")
  def deserialize(:hour, value), do: parse_and_normalize(:hour, value, "%Y-%m-%d-%H")
  def deserialize(:minute, value), do: parse_and_normalize(:minute, value, "%Y-%m-%d-%H-%M")
  def deserialize(:second, value), do: parse_and_normalize(:second, value, "%Y-%m-%d-%H-%M-%S")

  def normalize(:year, value), do: Date.from({ { value.year, 1, 1 },{ 0, 0, 0 } })
  def normalize(:month, value), do: Date.from({ { value.year, value.month, 1 },{ 0, 0, 0 } })
  def normalize(:day, value), do: Date.from({ { value.year, value.month, value.day }, { 0, 0, 0 } })
  def normalize(:hour, value), do: Date.from({ { value.year, value.month, value.day }, { value.hour, 0, 0 } })
  def normalize(:minute, value), do: Date.from({ { value.year, value.month, value.day }, { value.hour, value.minute, 0 } })
  def normalize(:second, value), do: Date.from({ { value.year, value.month, value.day }, { value.hour, value.minute, value.second } })

  def range(starting, ending, resolution) do
    starting_secs = normalize(resolution, starting) |> Date.convert(:secs)
    ending_secs = normalize(resolution, ending) |> Date.convert(:secs)
    next_in_range(starting_secs, ending_secs, resolution, [])
  end

  defp parse_and_normalize(unit, value, pattern) do
    { :ok, date } = DateFormat.parse(value, pattern, :strftime)
    normalize(unit, date)
  end

  defp next_in_range(starting_secs, ending_secs, resolution, acc) when starting_secs <= ending_secs do
    starting_time = Date.from(starting_secs, :secs, :epoch)
    next_time = case resolution do
      :year   -> Date.shift(starting_time, years: 1)
      :month  -> Date.shift(starting_time, months: 1)
      :day    -> Date.shift(starting_time, days: 1)
      :hour   -> Date.shift(starting_time, hours: 1)
      :minute -> Date.shift(starting_time, mins: 1)
      :second -> Date.shift(starting_time, secs: 1)
    end
    next_in_range(Date.convert(next_time, :secs), ending_secs, resolution, (acc ++ [starting_time]))
  end

  defp next_in_range(starting, ending, resolution, acc) do
    acc
  end

end
