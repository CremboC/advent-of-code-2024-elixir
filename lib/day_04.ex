import Day04Input
import Util

defmodule Day04 do
  def check(inp, {y, x}, idx, str) do
    curr = inp[y][x]
    curr != nil and curr == String.at(str, idx)
  end

  def east({y, x}, max), do: for(i <- 0..(max - 1), do: {y, x + i})
  def west({y, x}, max), do: for(i <- 0..(max - 1), do: {y, x - i})
  def north({y, x}, max), do: for(i <- 0..(max - 1), do: {y - i, x})
  def south({y, x}, max), do: for(i <- 0..(max - 1), do: {y + i, x})
  def northwest({y, x}, max), do: for(i <- 0..(max - 1), do: {y - i, x - i})
  def northeast({y, x}, max), do: for(i <- 0..(max - 1), do: {y - i, x + i})
  def southwest({y, x}, max), do: for(i <- 0..(max - 1), do: {y + i, x - i})
  def southeast({y, x}, max), do: for(i <- 0..(max - 1), do: {y + i, x + i})

  def valid?(inp, coords, str), do: valid?(inp, coords, 0, true, str)
  def valid?(_, _, _, acc, _) when not acc, do: acc
  def valid?(_, coords, _, acc, _) when coords == [], do: acc

  def valid?(inp, [head | tail], idx, acc, str),
    do: valid?(inp, tail, idx + 1, acc and check(inp, head, idx, str), str)

  def occurence_count(inp, yx, max, str) do
    [
      valid?(inp, east(yx, max), str),
      valid?(inp, west(yx, max), str),
      valid?(inp, north(yx, max), str),
      valid?(inp, south(yx, max), str),
      valid?(inp, northeast(yx, max), str),
      valid?(inp, northwest(yx, max), str),
      valid?(inp, southeast(yx, max), str),
      valid?(inp, southwest(yx, max), str)
    ]
    |> Enum.count(fn it -> it end)
  end

  def occurence_count_p2(inp, {y, x} = yx, max, str) do
    [
      valid?(inp, southeast(yx, max), str) and valid?(inp, northeast({y + 2, x}, max), str),
      valid?(inp, southwest(yx, max), str) and valid?(inp, northwest({y + 2, x}, max), str),
      valid?(inp, southeast(yx, max), str) and valid?(inp, southwest({y, x + 2}, max), str),
      valid?(inp, northeast(yx, max), str) and valid?(inp, northwest({y, x + 2}, max), str)
    ]
    |> Enum.count(fn it -> it end)
  end

  def part1() do
    inp = array_2d(input())
    max_y = Map.keys(inp) |> Enum.max()
    max_x = Map.keys(inp[0]) |> Enum.max()

    answer =
      for y <- 0..max_y,
          x <- 0..max_x,
          inp[y][x] == "X",
          reduce: 0 do
        acc -> acc + occurence_count(inp, {y, x}, 4, "XMAS")
      end

    IO.inspect(answer, label: "p1")
  end

  def part2() do
    inp = array_2d(input())
    max_y = Map.keys(inp) |> Enum.max()
    max_x = Map.keys(inp[0]) |> Enum.max()

    answer =
      for y <- 0..max_y,
          x <- 0..max_x,
          inp[y][x] == "M",
          reduce: 0 do
        acc -> acc + occurence_count_p2(inp, {y, x}, 3, "MAS")
      end

    IO.inspect(answer, label: "p2")
  end
end
