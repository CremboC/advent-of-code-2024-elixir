alias Matrix, as: M

defmodule Day12 do
  def matrix_perimeter(matrix),
    do:
      M.reduce(matrix, 0, fn {y, x}, _, acc ->
        acc + 4 - (M.neighbours({y, x}) |> Enum.count(fn {y, x} -> matrix[y][x] != nil end))
      end)

  def matrix_sides(matrix) do
    1
  end

  def subregion(matrix, start), do: subregion(matrix, MapSet.new([start]), %{})

  def subregion(matrix, queue, acc) do
    case queue |> Enum.take(1) do
      [] ->
        acc

      [_] ->
        acc_ =
          for {ly, lx} <- queue, reduce: acc do
            acc -> M.set(acc, {ly, lx}, matrix[ly][lx])
          end

        queue_ =
          for loc <- queue,
              {ny, nx} <- M.neighbours(loc),
              matrix[ny][nx] != nil and acc[ny][nx] == nil,
              reduce: MapSet.new() do
            queue_ -> MapSet.put(queue_, {ny, nx})
          end

        subregion(matrix, queue_, acc_)
    end
  end

  def solve(matrix, acc \\ 0, part \\ :part1) do
    case M.first(matrix) do
      nil ->
        acc

      {loc, _} ->
        subregion = subregion(matrix, loc)

        price =
          M.size(subregion) *
            case part do
              :part1 -> matrix_perimeter(subregion)
              :part2 -> matrix_sides(subregion)
            end

        solve(M.remove_locs(matrix, M.locs(subregion)), acc + price)
    end
  end

  def part1(input) do
    input
    |> M.from_string()
    |> M.group_by(fn _, val -> val end)
    |> Map.values()
    |> Enum.map(&M.from_yx_value_pairs/1)
    |> Enum.map(&solve/1)
    |> Enum.sum()
    |> IO.inspect(label: "p1")
  end

  def part2(input) do
    input
    |> M.from_string()
    |> M.group_by(fn _, val -> val end)
    |> Map.values()
    # |> Enum.take(1)
    |> Enum.map(&M.from_yx_value_pairs/1)
    # |> IO.inspect()
    |> Enum.map(&solve(&1, 0, :part2))
    # |> IO.inspect()
    |> Enum.sum()
    |> IO.inspect()

    m =
      """
      x...
      x...
      xx..
      x...
      x...
      """
      |> M.from_string()

    # start with {min(y), min(x)}
    # start side
    # check north, if nothing, it's
    #

    region =
      m
      |> M.group_by(fn _, val -> val end)
      |> Map.values()
      |> Enum.drop(1)
      |> Enum.take(1)
      |> hd()
      |> M.from_yx_value_pairs()
      |> IO.inspect(label: "hd")
      |> subregion({0, 1})

    region
    |> M.filter(fn loc, _ ->
      M.neighbours(loc)
      |> Enum.filter(&Loc.valid?(&1, region))
      |> IO.inspect(label: "neighbours of #{inspect(loc)}")
      |> length() < 4
    end)
    |> IO.inspect()
    |> M.from_yx_value_pairs()
    |> M.group_by(fn {y, x}, _ -> x end)
    |> IO.inspect()

    # group by same x,
    # within group, iteratively split by sequences of y
    # e.g. [1, 2, 3, 7, 8, 9]
    # [[1, 2, 3], [7, 8, 9]]

    m
    |> matrix_sides()
    |> IO.inspect()

    1
  end
end
