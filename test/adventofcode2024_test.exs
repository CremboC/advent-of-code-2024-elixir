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

  test "day04" do
    assert Day04.part1() == 2603
    assert Day04.part2() == 1965
  end

  test "day05" do
    assert Day05.part1() > 0
    assert Day05.part2() > 0
  end

  test "day06" do
    assert Day06.part1() == 4964
    assert Day06.part2() >= 0
  end

  test "day07" do
    assert Day07.part1() == 3_245_122_495_150
    assert Day07.part2() == 105_517_128_211_543
  end

  test "day08" do
    assert Day08.part1(Day08Input.input()) == 329
    assert Day08.part2(Day08Input.input()) == 1190
  end

  test "day09" do
    # Day09.part1(Day09Input.input_example_1())
    Day09.part2(Day09Input.input())
  end
end
