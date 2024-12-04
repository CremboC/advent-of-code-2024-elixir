defmodule Day04Input do
  def input_example() do
    """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """
  end

  def input_example_2() do
    """
    S..S
    AAA.
    MMM.
    X..X
    """
  end

  def input() do
    File.read!("inputs/day04.txt")
  end
end
