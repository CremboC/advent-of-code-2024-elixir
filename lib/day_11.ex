import Util

defmodule Day11 do
  require Integer

  def blink(freqs) do
    for {number, times} <- freqs, reduce: %{} do
      acc ->
        cond do
          number == "0" ->
            acc |> Map.update("1", times, &(&1 + times))

          Integer.is_even(String.length(number)) ->
            {l, r} = String.split_at(number, div(String.length(number), 2))
            il = Integer.to_string(int!(l))
            ir = Integer.to_string(int!(r))

            acc |> Map.update(il, times, &(&1 + times)) |> Map.update(ir, times, &(&1 + times))

          true ->
            acc |> Map.update(Integer.to_string(int!(number) * 2024), times, &(&1 + times))
        end
    end
  end

  def solve(input, n) do
    stones = String.split(input) |> Enum.frequencies()

    0..(n - 1)
    |> Enum.reduce(stones, fn _, acc -> blink(acc) end)
    |> Map.values()
    |> Enum.sum()
  end

  def part1(input) do
    solve(input, 25) |> IO.inspect(label: "p1")
  end

  def part2(input) do
    solve(input, 75) |> IO.inspect(label: "p2")
  end
end
