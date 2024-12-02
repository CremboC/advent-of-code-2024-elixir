import Day01Input

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
      |> Enum.zip_reduce(0, fn [l, r], acc -> acc + abs(l - r) end)

    IO.inspect(result)
  end

  def part2() do
    [l, r] = both_lists(input())
    freqs = Enum.frequencies(r)

    result =
      Enum.reduce(l, 0, fn elem, acc -> acc + Map.get(freqs, elem, 0) * elem end)

    IO.inspect(result)
  end
end
