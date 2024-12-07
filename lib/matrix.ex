defmodule Matrix do
  def print(inp), do: for({_, y} <- inp, do: IO.inspect(Map.values(y)))

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

  # def find_first_loc(inp, loc, dir, finder) do
  #   case dir do
  #     :north -> north(loc)
  #     :east -> east(loc)
  #     :south -> south(loc)
  #     :west -> west(loc)
  #   end
  #   # :cont | :halt
  #   |> Stream.map(fn {y, x} = next -> {next, finder.(inp[y][x])} end)
  #   |> Stream.drop_while(fn {_, action} -> action != :halt end)
  #   |> Stream.take(1)
  #   |> Enum.to_list()
  #   |> hd
  # end

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
  # for(i <- 0..(max - 1), do: {y, x + i})
  # def west({y, x}, max), do: for(i <- 0..(max - 1), do: {y, x - i})
  # def north({y, x}, max), do: for(i <- 0..(max - 1), do: {y - i, x})
  # def south({y, x}, max), do: for(i <- 0..(max - 1), do: {y + i, x})
end
