import Day01Input
import Function, only: [identity: 1]

defmodule Day01 do
  def both_lists(input) do
    pairs =
      for ln <- String.split(input, "\n"),
          ln != "",
          [{li, _}, {ri, _}] = Enum.map(~w(#{ln}), &Integer.parse/1),
          do: {li, ri}

    Enum.reduce(pairs, [[], []], fn {l, r}, [accl, accr] ->
      [[l | accl], [r | accr]]
    end)
  end

  def part1 do
    result =
      both_lists(input())
      |> Enum.map(&Enum.sort(&1))
      |> Enum.zip()
      |> Enum.map(fn {l, r} -> abs(l - r) end)
      |> Enum.sum()

    IO.inspect(result)
  end

  def part2() do
    [l, r] = both_lists(input())
    o = Enum.group_by(r, &identity/1) |> Map.new(fn {k, v} -> {k, Enum.count(v)} end)
    result = Enum.reduce(l, 0, fn elem, acc -> acc + Map.get(o, elem, 0) * elem end)
    IO.inspect(result)
  end
end
