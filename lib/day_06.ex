import Day06Input
import Util
import Matrix

defmodule Day06 do
  @next %{
    "^" => ">",
    ">" => "v",
    "<" => "^",
    "v" => "<"
  }

  def go(dir, loc) do
    case dir do
      "^" -> north(loc)
      ">" -> east(loc)
      "<" -> west(loc)
      "v" -> south(loc)
    end
  end

  def navigate(dir, loc, inp) do
    go(dir, loc)
    |> Stream.scan({nil, {[], inp}}, fn {y, x} = v, {_, {acc_v, acc_inp}} ->
      case inp[y][x] do
        "#" -> {:wall, {acc_v, acc_inp}}
        nil -> {:escaped, {acc_v, acc_inp}}
        _ -> {:cont, {[v | acc_v], put_in(acc_inp[y][x], "X")}}
      end
    end)
    |> Stream.drop_while(fn {action, _} -> action == :cont end)
    |> Stream.take(1)
    |> Enum.to_list()
    |> then(fn
      [{:wall, {[next_loc | _], next_inp}}] ->
        navigate(@next[dir], next_loc, next_inp)

      [{:escaped, {_, next_inp}}] ->
        next_inp
    end)
  end

  def part1 do
    inp = array_2d(input())
    [{ys, xs} = loc] = get_locs_by(inp, &(&1 == "^"))

    dir = inp[ys][xs]
    inp = put_in(inp[ys][xs], ".")
    answer = navigate(dir, loc, inp) |> get_locs_by(&(&1 == "X")) |> Enum.count()

    IO.inspect(answer, label: "p1")
  end

  def part2() do
    IO.inspect(0, label: "p2")
  end
end
