defmodule Matrix do
  def from_string(string),
    do:
      Util.lines(string)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {ln, y}, acc ->
        %{
          y =>
            String.graphemes(ln)
            |> Enum.with_index()
            |> Enum.reduce(%{}, fn {c, x}, acc -> Map.merge(acc, %{x => c}) end)
        }
        |> Map.merge(acc)
      end)

  def print(inp), do: for({_, y} <- inp, do: IO.puts(Map.values(y) |> Enum.join("")))

  def to_string(inp),
    do: for({_, y} <- inp, do: Map.values(y) |> Enum.join("")) |> Enum.join("\n")

  def reduce(matrix, acc, f) do
    for {y, row} <- matrix, {x, cell} <- row, reduce: acc do
      acc -> f.({y, x}, cell, acc)
    end
  end

  def group_by(matrix, f) do
    for {y, row} <- matrix, {x, cell} <- row, value = {{y, x}, cell}, reduce: %{} do
      acc ->
        Map.update(acc, f.({y, x}, cell), [value], &[value | &1])
    end
  end

  def group_map(matrix, g, f) do
    for {y, row} <- matrix, {x, cell} <- row, reduce: %{} do
      acc ->
        Map.update(acc, g.({y, x}, cell), [f.({y, x}, cell)], &[f.({y, x}, cell) | &1])
    end
  end

  def get_locs_by(inp, func) do
    for {y, row} <- inp, {x, item} <- row, reduce: [] do
      acc -> if(func.(item), do: [{y, x} | acc], else: acc)
    end
  end

  def next_loc_until(inp, dir, {y, x} = loc, finder) do
    case finder.(inp[y][x]) do
      :halt -> loc
      :cont -> next_loc_until(inp, dir, next_loc(dir, loc), finder)
    end
  end

  def east({y, x}), do: Stream.iterate(0, &(&1 + 1)) |> Stream.map(&{y, x + &1})
  def west({y, x}), do: Stream.iterate(0, &(&1 + 1)) |> Stream.map(&{y, x - &1})
  def north({y, x}), do: Stream.iterate(0, &(&1 + 1)) |> Stream.map(&{y - &1, x})
  def south({y, x}), do: Stream.iterate(0, &(&1 + 1)) |> Stream.map(&{y + &1, x})

  def next_loc(dir, loc) do
    case dir do
      :north -> next_north(loc)
      :east -> next_east(loc)
      :south -> next_south(loc)
      :west -> next_west(loc)
    end
  end

  def next_east({y, x}), do: {y, x + 1}
  def next_south({y, x}), do: {y + 1, x}
  def next_west({y, x}), do: {y, x - 1}
  def next_north({y, x}), do: {y - 1, x}
end
