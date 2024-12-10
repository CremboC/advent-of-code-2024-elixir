defmodule Day10Input do
  def input_example() do
    """
    0123
    1234
    8765
    9876
    """
  end

  def input_example_1() do
    """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """
  end

  def input_example_2() do
    """
    10..9..
    2...8..
    3...7..
    4567654
    ...8..3
    ...9..2
    .....01
    """
  end

  def input_example_3() do
    """
    89010123
    78121874
    87430965
    96549874
    45678903
    32019012
    01329801
    10456732
    """
  end

  def input() do
    File.read!("inputs/day10.txt")
  end
end
