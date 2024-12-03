defmodule Adventofcode2024Test do
  use ExUnit.Case

  test "day01" do
    assert Day01.part1() == 1_970_720
    assert Day01.part2() == 17_191_599
  end

  test "day02" do
    assert Day02.part1() == 486
    assert Day02.part2() == 540
  end

  test "day03" do
    assert Day03.part1() == 161_085_926
    assert Day03.part2() == 82_045_421
  end
end
