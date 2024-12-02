import Day02Input
import Util

defmodule Day02 do
  def change_dir([l, r]) when l == r, do: :none
  def change_dir([l, r]) when l < r, do: :incr
  def change_dir([l, r]) when l > r, do: :decr

  def safe_diff?([l, r]), do: Enum.member?(1..3, abs(l - r))

  def is_safe?(level) do
    {dir, safe?} =
      Enum.chunk_every(level, 2, 1, :discard)
      |> Enum.map(fn pair -> {change_dir(pair), safe_diff?(pair)} end)
      |> Enum.reduce_while(nil, fn
        {dir, _}, _ when dir == :none ->
          {:halt, {dir, false}}

        {dir, safe?}, acc when acc == nil ->
          {:cont, {dir, safe?}}

        {dir, safe?}, {acc_dir, acc_safe?} when dir == acc_dir ->
          {:cont, {dir, safe? and acc_safe?}}

        {dir, _}, {acc_dir, _} when dir != acc_dir ->
          {:halt, {dir, false}}
      end)

    dir != :none and safe?
  end

  def recursive_is_safe?(level, idx) do
    if idx == Enum.count(level) do
      false
    else
      is_safe?(List.delete_at(level, idx)) or recursive_is_safe?(level, idx + 1)
    end
  end

  def part1() do
    answer =
      for ln <- lines(input()),
          level = integer_list_from_str(ln),
          is_safe?(level),
          reduce: 0 do
        acc -> acc + 1
      end

    IO.inspect(answer)
  end

  def part2() do
    answer =
      for ln <- lines(input()),
          level = integer_list_from_str(ln),
          recursive_is_safe?(level, 0),
          reduce: 0 do
        acc -> acc + 1
      end

    IO.inspect(answer)
  end
end
