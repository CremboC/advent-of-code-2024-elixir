import Util

defmodule Day13 do
  def solve([
        [?A, ax, ay],
        [?B, bx, by],
        [tx, ty]
      ]) do
    # 94a <= 8400 (x) (89.nn => 90)
    # 34a <= 5400 (y) (158.nn => 159)
    # and
    # 22b <= 8400 (x) (381.nnn => 382)
    # 67b <= 5400 (y) (80.nnn => 81) => 67*81
    max_a = min(div(tx, ax) + 1, div(ty, ay) + 1) |> IO.inspect(label: "max_a")
    max_b = min(div(tx, bx) + 1, div(ty, by) + 1) |> IO.inspect(label: "max_b")

    min =
      for a <- 1..max_a,
          b <- 1..max_b,
          ax * a + bx * b == tx,
          ay * a + by * b == ty,
          reduce: nil do
        acc -> min(3 * a + b, acc)
      end

    min || 0
  end

  def part1(input) do
    input
    |> lines()
    |> Enum.map(&Day13Parser.combo/1)
    |> Enum.filter(&(elem(&1, 0) == :ok))
    |> Enum.map(&elem(&1, 1))
    # |> IO.inspect(charlists: :as_lists)
    |> Enum.chunk_every(3, 3)
    # |> IO.inspect(charlists: :as_lists)
    |> Enum.map(&solve/1)
    # |> IO.inspect(charlists: :as_lists)
    |> Enum.sum()
    |> IO.inspect(label: "p1")
  end

  def part2(input) do
    input
    |> lines()
    |> Enum.map(&Day13Parser.combo/1)
    |> Enum.filter(&(elem(&1, 0) == :ok))
    |> Enum.map(&elem(&1, 1))
    |> Enum.chunk_every(3, 3)
    |> Enum.map(fn [a, b, [tx, ty]] ->
      [a, b, [tx + 10_000_000_000_000, ty + 10_000_000_000_000]]
    end)
    |> IO.inspect(charlists: :as_lists)
    |> Enum.map(&solve/1)
    |> IO.inspect(charlists: :as_lists)
    |> Enum.sum()
    |> IO.inspect(label: "p2")
  end
end

defmodule Day13Parser do
  import NimbleParsec

  button =
    ignore(string("Button "))
    |> ascii_char([?A, ?B])
    |> ignore(string(": X+"))
    |> integer(min: 1)
    |> ignore(string(", Y+"))
    |> integer(min: 1)

  prize =
    ignore(string("Prize: X="))
    |> integer(min: 1)
    |> ignore(string(", Y="))
    |> integer(min: 1)

  combo =
    choice([button, prize])

  defparsec(:combo, combo)
end
