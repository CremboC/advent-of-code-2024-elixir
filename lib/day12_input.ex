defmodule Day12Input do
  def input_example() do
    """
    AAAA
    BBCD
    BBCC
    EEEC
    """
  end

  def input_example_2() do
    """
    OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO
    """
  end

  def input_example_3() do
    """
    RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE
    """
  end

  def input() do
    File.read!("inputs/day12.txt")
  end
end
