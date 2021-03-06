defmodule ResolutionTest do
  use ExUnit.Case
  use Timex
  alias Tabs.Resolution

  setup do
    gmt = Date.timezone("GMT")
    date = Date.from({ { 2014, 3, 5 }, { 23, 25, 19 } }, gmt)
    { :ok, date: date }
  end

  test "serializers work as expected", %{ date: date } do
    assert Resolution.serialize(:year, date) == "2014"
    assert Resolution.serialize(:month, date) == "2014-03"
    assert Resolution.serialize(:day, date) == "2014-03-05"
    assert Resolution.serialize(:hour, date) == "2014-03-05-23"
    assert Resolution.serialize(:minute, date) == "2014-03-05-23-25"
    assert Resolution.serialize(:second, date) == "2014-03-05-23-25-19"
  end

  test "deserializers work as expected" do
    assert Resolution.deserialize(:year, "2014") == Date.from({ { 2014, 1, 1 }, { 0, 0, 0} })
    assert Resolution.deserialize(:month, "2014-03") == Date.from({ { 2014, 3, 1 }, { 0, 0, 0} })
    assert Resolution.deserialize(:day, "2014-03-05") == Date.from({ { 2014, 3, 5 }, { 0, 0, 0} })
    assert Resolution.deserialize(:hour, "2014-03-05-23") == Date.from({ { 2014, 3, 5 }, { 23, 0, 0} })
    assert Resolution.deserialize(:minute, "2014-03-05-23-25") == Date.from({ { 2014, 3, 5 }, { 23, 25, 0} })
    assert Resolution.deserialize(:second, "2014-03-05-23-25-19") == Date.from({ { 2014, 3, 5 }, { 23, 25, 19} })
  end

  test "normalizers work as expected", %{ date: date } do
    assert Resolution.normalize(:year, date) == Date.from({ { date.year, 1, 1 }, { 0, 0, 0} })
    assert Resolution.normalize(:month, date) == Date.from({ { date.year, date.month, 1 }, { 0, 0, 0} })
    assert Resolution.normalize(:day, date) == Date.from({ { date.year, date.month, date.day }, { 0, 0, 0} })
    assert Resolution.normalize(:hour, date) == Date.from({ { date.year, date.month, date.day }, { date.hour, 0, 0} })
    assert Resolution.normalize(:minute, date) == Date.from({ { date.year, date.month, date.day }, { date.hour, date.minute, 0} })
    assert Resolution.normalize(:second, date) == Date.from({ { date.year, date.month, date.day }, { date.hour, date.minute, date.second} })
  end

  test "range() returns the correct range for days" do
    t1 = Date.from({ { 2014, 1, 1 }, { 23, 7, 22 } })
    t2 = Date.from({ { 2014, 1, 4 }, { 3, 19, 58 } })
    range = Resolution.range(t1, t2, :day)
    assert range == [
      Date.from({ { 2014, 1, 1 }, { 0, 0, 0 } }),
      Date.from({ { 2014, 1, 2 }, { 0, 0, 0 } }),
      Date.from({ { 2014, 1, 3 }, { 0, 0, 0 } }),
      Date.from({ { 2014, 1, 4 }, { 0, 0, 0 } })
    ]
  end

  test "range() returns the correct range for hours" do
    t1 = Date.from({ { 2014, 1, 1 }, { 2, 7, 22 } })
    t2 = Date.from({ { 2014, 1, 1 }, { 5, 19, 58 } })
    range = Resolution.range(t1, t2, :hour)
    assert range == [
      Date.from({ { 2014, 1, 1 }, { 2, 0, 0 } }),
      Date.from({ { 2014, 1, 1 }, { 3, 0, 0 } }),
      Date.from({ { 2014, 1, 1 }, { 4, 0, 0 } }),
      Date.from({ { 2014, 1, 1 }, { 5, 0, 0 } })
    ]
  end

  test "range() returns the correct range for minutes" do
    t1 = Date.from({ { 2014, 1, 1 }, { 1, 7, 22 } })
    t2 = Date.from({ { 2014, 1, 1 }, { 1, 10, 58 } })
    range = Resolution.range(t1, t2, :minute)
    assert range == [
      Date.from({ { 2014, 1, 1 }, { 1, 7, 0 } }),
      Date.from({ { 2014, 1, 1 }, { 1, 8, 0 } }),
      Date.from({ { 2014, 1, 1 }, { 1, 9, 0 } }),
      Date.from({ { 2014, 1, 1 }, { 1, 10, 0 } })
    ]
  end

end
