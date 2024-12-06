import Day05Input
import Util

defmodule Day05 do
  def parse(input) do
    lines_raw(input)
    |> Enum.split_while(fn ln -> ln != "" end)
    |> then(fn {orders, updates} ->
      {orders |> Enum.map(&integer_list_from_str(&1, "|")),
       updates |> clean_list() |> Enum.map(&integer_list_from_str(&1, ","))}
    end)
  end

  def ordering_map(orders) do
    Enum.group_by(orders, fn [n, _] -> n end)
    |> Enum.reduce(%{}, fn {k, vs}, acc ->
      Map.merge(acc, %{k => Enum.flat_map(vs, &tl/1)})
    end)
  end

  def next_ok?(_, [], _), do: true

  def next_ok?(target, [head | tail] = rest, orders) do
    # list of number target should be ahead of
    # does tail contain anything from this list?
    # if yes, then it's wrong
    (orders[target] == nil or not Enum.any?(rest, &Enum.member?(orders[target], &1))) and
      next_ok?(head, tail, orders)
  end

  def update_ok?(update, orders) do
    [head | tail] = Enum.reverse(update)
    next_ok?(head, tail, orders)
  end

  def fix_order(lst, orders) do
    # orders === {number => [has_to_be_before_these...]}
    sorter = fn {a, ai}, {b, bi} ->
      cond do
        orders[a] == nil -> ai < bi
        Enum.member?(orders[a], b) -> false
        true -> true
      end
    end

    lst
    |> Enum.with_index()
    |> Enum.sort_by(fn it -> it end, sorter)
    |> Enum.map(fn {it, _} -> it end)
  end

  def part1() do
    {orders, updates} = parse(input())
    orders = ordering_map(orders)

    answer =
      for u <- updates,
          update_ok?(u, orders),
          reduce: 0 do
        acc -> acc + Enum.at(u, floor(length(u) / 2))
      end

    IO.inspect(answer, label: "p1")
  end

  def part2() do
    {orders, updates} = parse(input())
    orders = ordering_map(orders)

    answer =
      Enum.reject(updates, &update_ok?(&1, orders))
      |> Enum.map(&fix_order(&1, orders))
      |> Enum.reduce(0, &(&2 + Enum.at(&1, floor(length(&1) / 2))))

    IO.inspect(answer, label: "p2")
  end
end
