import Day08Input
import Util
alias Matrix, as: M

defmodule Day08 do
  def part1(input \\ input()) do
    {inp, _} = input
    matrix = M.from_string(inp)

    lookup =
      matrix
      |> M.group_map(fn _, v -> v end, fn loc, _ -> loc end)
      |> Map.delete(".")

    added =
      for {_, vs} <- lookup,
          {l, r} <- uniq_pairs(vs),
          min = Loc.min(l, r),
          max = Loc.max(l, r),
          vec = Loc.vector(max, min),
          reduce: MapSet.new() do
        acc ->
          antinodes =
            [
              Loc.sub(min, vec),
              Loc.add(max, vec)
            ]
            |> Enum.filter(&Loc.valid?(&1, matrix))

          MapSet.union(acc, MapSet.new(antinodes))
      end

    added |> MapSet.size() |> IO.inspect(label: "p1")
  end

  def part2(input \\ input()) do
    {inp, _} = input
    matrix = M.from_string(inp)

    lookup =
      matrix
      |> M.group_map(fn _, v -> v end, fn loc, _ -> loc end)
      |> Map.delete(".")

    added =
      for {_, vs} <- lookup,
          {l, r} <- uniq_pairs(vs),
          min = Loc.min(l, r),
          max = Loc.max(l, r),
          vec = Loc.vector(max, min),
          reduce: MapSet.new() do
        acc ->
          pre =
            Stream.iterate(min, &Loc.sub(&1, vec))
            |> Stream.take_while(&Loc.valid?(&1, matrix))
            |> Enum.to_list()
            |> MapSet.new()

          post =
            Stream.iterate(max, &Loc.add(&1, vec))
            |> Stream.take_while(&Loc.valid?(&1, matrix))
            |> Enum.to_list()
            |> MapSet.new()

          acc
          |> MapSet.union(pre)
          |> MapSet.union(post)
      end

    added |> MapSet.size() |> IO.inspect(label: "p1")
  end
end
