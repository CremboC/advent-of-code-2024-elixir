import Util
alias Matrix, as: M
alias Aja.Vector, as: Vec

defmodule Day10 do
  def solve_p1(matrix, {y, x} = curr) do
    if matrix[y][x] == "9" do
      MapSet.new([{y, x}])
    else
      for {ny, nx} = next <- M.neighbours(curr),
          Loc.valid?(next, matrix),
          int?(matrix[ny][nx]),
          int!(matrix[ny][nx]) - int!(matrix[y][x]) == 1,
          reduce: MapSet.new() do
        acc ->
          MapSet.union(acc, solve_p1(matrix, next))
      end
    end
  end

  def solve_p2(matrix, {y, x} = curr, path \\ Vec.new(), paths \\ Vec.new()) do
    if matrix[y][x] == "9" do
      Vec.append(paths, Vec.append(path, {y, x}))
    else
      for {ny, nx} = next <- M.neighbours(curr),
          Loc.valid?(next, matrix),
          int?(matrix[ny][nx]),
          int!(matrix[ny][nx]) - int!(matrix[y][x]) == 1,
          reduce: paths do
        acc ->
          Vec.concat(
            acc,
            solve_p2(matrix, next, Vec.append(path, {y, x}), paths)
          )
      end
    end
  end

  def part1(input) do
    matrix = M.from_string(input)

    M.get_locs_by(matrix, fn v -> v == "0" end)
    |> Enum.map(&MapSet.size(solve_p1(matrix, &1)))
    |> Enum.sum()
    |> IO.inspect(label: "p1")
  end

  def part2(input) do
    matrix = M.from_string(input)

    M.get_locs_by(matrix, fn v -> v == "0" end)
    |> Enum.map(&Vec.size(solve_p2(matrix, &1)))
    |> Enum.sum()
    |> IO.inspect(label: "p2")
  end
end
