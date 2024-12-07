defmodule Day06Input do
  def input_example() do
    """
    ....#.....
    .........#
    ..........
    ..#.......
    .......#..
    ..........
    .#..^.....
    ........#.
    #.........
    ......#...
    """
  end

  def input_example_2() do
    """
    ....#.....

    ........#

    ....^...#.
    """
  end

  def input() do
    File.read!("inputs/day06.txt")
  end
end
