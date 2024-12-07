import Day07Input
import Util

defmodule Day07 do
  def gen([], _), do: [[]]

  def gen([_ | []], _), do: [[]]

  def gen([head, next | tail], options) do
    for opt <- options,
        nxt <- gen([next | tail], options),
        do: [{head, opt, next} | nxt]
  end

  def op!({a, "*", b}), do: a * b
  def op!({a, "+", b}), do: a + b
  def op!({a, "||", b}), do: int!("#{a}#{b}")

  def apply([head | []]), do: op!(head)

  def apply([head, {_, op1, b1} | tail]),
    do: apply([{op!(head), op1, b1} | tail])

  def part1() do
    options = ["*", "+"]

    inp =
      for ln <- lines(input()),
          [target, num_string] = String.split(ln, ":"),
          do: {int!(target), integer_list_from_str(num_string)}

    answer =
      for {target, nums} <- inp,
          Enum.any?(gen(nums, options), &(apply(&1) == target)),
          reduce: 0 do
        acc -> acc + target
      end

    IO.inspect(answer, label: "p1")
  end

  def part2() do
    options = ["*", "+", "||"]

    inp =
      for ln <- lines(input()),
          [target, num_string] = String.split(ln, ":"),
          do: {int!(target), integer_list_from_str(num_string)}

    answer =
      inp
      |> Task.async_stream(
        fn {target, nums} ->
          if(Enum.any?(gen(nums, options), &(apply(&1) == target)), do: target, else: 0)
        end,
        ordered: false
      )
      |> Stream.map(fn {:ok, res} -> res end)
      |> Enum.to_list()
      |> Enum.sum()

    IO.inspect(answer, label: "p2")
  end
end
