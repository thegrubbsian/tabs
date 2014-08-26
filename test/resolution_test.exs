defmodule ResolutionTest do
  use ExUnit.Case
  use Timex

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

end
