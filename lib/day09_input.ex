defmodule Day09Input do
  def input_example() do
    "12345"
  end

  def input_example_1() do
    "2333133121414131402"
  end

  def input_example_2() do
    "90909"
  end

  def input() do
    File.read!("inputs/day09.txt") |> String.trim()
  end
end
