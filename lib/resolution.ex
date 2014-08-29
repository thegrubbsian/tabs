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

  defp parse_and_normalize(unit, value, pattern) do
    { :ok, date } = DateFormat.parse(value, pattern, :strftime)
    normalize(unit, date)
  end

end
