defmodule Matrix do
  def from_string(string, mapper \\ &Function.identity/1),
    do:
      Util.lines(string)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {ln, y}, acc ->
        %{
          y =>
            String.graphemes(ln)
            |> Enum.with_index()
            |> Enum.reduce(%{}, fn {c, x}, acc -> Map.merge(acc, %{x => mapper.(c)}) end)
        }
        |> Map.merge(acc)
      end)

  def from_yx_value_pairs(pairs) do
    for {{y, x}, v} <- pairs, reduce: %{} do
      acc -> Map.update(acc, y, %{x => v}, fn col -> put_in(col[x], v) end)
    end
  end

  def print(inp) do
    {max_y, max_x} =
      for {y, row} <- inp, {x, _} <- row, reduce: {0, 0} do
        {max_y, max_x} ->
          {max(y, max_y), max(x, max_x)}
      end

    for y <- 0..max_y,
        if(inp[y], do: IO.puts(""), else: IO.puts(String.duplicate(".", max_x))),
        inp[y],
        max_x = Map.keys(inp[y]) |> Enum.max(),
        x <- 0..max_x do
      value = inp[y][x]
      IO.write(if(value, do: value, else: "."))
    end

    IO.puts("")
  end

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

  def filter(inp, func) do
    for {y, row} <- inp, {x, item} <- row, reduce: [] do
      acc -> if(func.({y, x}, item), do: [{{y, x}, item} | acc], else: acc)
    end
  end

  def next_loc_until(inp, dir, {y, x} = loc, finder) do
    case finder.(inp[y][x]) do
      :halt -> loc
      :cont -> next_loc_until(inp, dir, next_loc(dir, loc), finder)
    end
  end

  def first(matrix) do
    case matrix |> Enum.take(1) do
      [] ->
        nil

      [{y, row}] ->
        case row |> Enum.take(1) do
          [] -> nil
          [{x, v}] -> {{y, x}, v}
        end
    end
  end

  def set(matrix, {y, x}, value) do
    update_in(matrix[y], fn
      nil -> %{x => value}
      row -> put_in(row[x], value)
    end)
  end

  def locs(matrix), do: for({y, row} <- matrix, {x, _} <- row, do: {y, x})

  def size(matrix) do
    for {_, row} <- matrix, _ <- row, reduce: 0 do
      acc -> acc + 1
    end
  end

  def remove_locs(matrix, locs) do
    for {y, x} <- locs, reduce: matrix do
      acc ->
        acc = pop_in(acc[y][x]) |> elem(1)

        cond do
          map_size(acc[y]) == 0 -> pop_in(acc[y]) |> elem(1)
          true -> acc
        end
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

  def neighbours(loc),
    do: [
      next_north(loc),
      next_east(loc),
      next_south(loc),
      next_west(loc)
    ]
end
