defmodule Matrix do
  def print(inp), do: for({_, y} <- inp, do: IO.inspect(Map.values(y)))

  def get_locs_by(inp, func) do
    for {y, row} <- inp, {x, item} <- row, reduce: [] do
      acc -> if(func.(item), do: [{y, x} | acc], else: acc)
    end
  end

  def east({y, x}), do: Stream.iterate(0, &(&1 + 1)) |> Stream.map(&{y, x + &1})
  def west({y, x}), do: Stream.iterate(0, &(&1 + 1)) |> Stream.map(&{y, x - &1})
  def north({y, x}), do: Stream.iterate(0, &(&1 + 1)) |> Stream.map(&{y - &1, x})
  def south({y, x}), do: Stream.iterate(0, &(&1 + 1)) |> Stream.map(&{y + &1, x})
  # for(i <- 0..(max - 1), do: {y, x + i})
  # def west({y, x}, max), do: for(i <- 0..(max - 1), do: {y, x - i})
  # def north({y, x}, max), do: for(i <- 0..(max - 1), do: {y - i, x})
  # def south({y, x}, max), do: for(i <- 0..(max - 1), do: {y + i, x})
end
