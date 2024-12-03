import Day01Input
import Util

defmodule Day01 do
  def both_lists(input) do
    for ln <- lines(input),
        [l, r] = integer_list_from_str(ln, "   "),
        reduce: [[], []] do
      [accl, accr] -> [[l | accl], [r | accr]]
    end
  end

  def part1 do
    result =
      both_lists(input())
      |> Enum.map(&Enum.sort(&1))
      |> Enum.zip_reduce(0, fn [l, r], acc -> acc + abs(l - r) end)

    IO.inspect(result, label: "p1")
  end

  def part2() do
    [l, r] = both_lists(input())
    freqs = Enum.frequencies(r)

    result =
      Enum.reduce(l, 0, fn elem, acc -> acc + Map.get(freqs, elem, 0) * elem end)

    IO.inspect(result, label: "p2")
  end
end
