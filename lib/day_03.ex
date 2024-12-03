import Day03Input
import Util

defmodule Day03 do
  def part1() do
    answer =
      for [_, l, r] <- Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)/, input()),
          reduce: 0 do
        acc -> acc + int!(l) * int!(r)
      end

    IO.inspect(answer, label: "p2")
  end

  def part2() do
    {answer, _} =
      for match <- Regex.scan(~r/mul\((\d{1,3}),(\d{1,3})\)|(don't\(\))|(do\(\))/, input()),
          reduce: {0, :do} do
        {i, state} ->
          case match do
            ["don't()" | _] ->
              {i, :dont}

            ["do()" | _] ->
              {i, :do}

            [_, a, b] when state == :do ->
              {i + int!(a) * int!(b), :do}

            _ when state == :dont ->
              {i, :dont}
          end
      end

    IO.inspect(answer, label: "p2")
  end
end
