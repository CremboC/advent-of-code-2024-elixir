import Day06Input
import Util
import Matrix

defmodule Day06 do
  @next %{
    :north => :east,
    :east => :south,
    :south => :west,
    :west => :north
  }

  def navigate(dir, {y, x} = loc, inp, visited) do
    visited = MapSet.put(visited, {y, x})
    {ny, nx} = nloc = next_loc(dir, loc)
    ndir = @next[dir]

    case inp[ny][nx] do
      nil -> visited
      "#" -> navigate(ndir, next_loc(ndir, loc), inp, visited)
      _ -> navigate(dir, nloc, inp, visited)
    end
  end

  def has_loop?(dir, loc, inp, visits) do
    visits =
      update_in(visits[loc], fn
        nil -> 1
        it -> it + 1
      end)

    cond do
      visits[loc] > 4 ->
        true

      true ->
        {ny, nx} = nloc = next_loc(dir, loc)
        ndir = @next[dir]

        case inp[ny][nx] do
          nil -> false
          "#" -> has_loop?(ndir, next_loc(ndir, loc), inp, visits)
          _ -> has_loop?(dir, nloc, inp, visits)
        end
    end
  end

  def navigate_p2(dir, {y, x} = loc, inp, visited) do
    visited = MapSet.put(visited, {dir, y, x})
    {ny, nx} = nloc = next_loc(dir, loc)
    ndir = @next[dir]

    case inp[ny][nx] do
      nil -> visited
      "#" -> navigate_p2(ndir, next_loc(ndir, loc), inp, visited)
      _ -> navigate_p2(dir, nloc, inp, visited)
    end
  end

  def part1 do
    inp = Matrix.from_string(input())
    [{ys, xs} = loc] = get_locs_by(inp, &(&1 == "^"))

    inp = put_in(inp[ys][xs], ".")
    answer = navigate(:north, loc, inp, MapSet.new()) |> MapSet.size()

    IO.inspect(answer, label: "p1")
  end

  def placed_obstacles([], _, acc), do: acc

  def placed_obstacles([{dir, y, x} | tail], inp, acc) do
    # IO.inspect({y, x}, label: "checking")
    next_dir = @next[dir]

    attempt? =
      next_loc_until(inp, next_dir, {y, x}, fn
        "#" -> :halt
        nil -> :halt
        _ -> :cont
      end)
      |> Loc.valid?(inp)

    {ahead_y, ahead_x} = ahead_loc = next_loc(dir, {y, x}) |> IO.inspect()

    next_acc =
      if attempt? and
           Loc.valid?(ahead_loc, inp) and
           has_loop?(
             next_dir,
             next_loc(next_dir, {y, x}),
             put_in(inp[ahead_y][ahead_x], "#"),
             %{}
           ) do
        MapSet.put(acc, {y, x})
      else
        acc
      end

    placed_obstacles(tail, inp, next_acc)
  end

  def part2() do
    inp = Matrix.from_string(input_example())
    [{ys, xs} = loc] = get_locs_by(inp, &(&1 == "^"))

    inp = put_in(inp[ys][xs], ".")
    visited = navigate_p2(:north, loc, inp, MapSet.new())

    answer =
      placed_obstacles(MapSet.to_list(visited), inp, MapSet.new())
      |> MapSet.delete({ys, xs})

    # |> IO.inspect()
    # |> MapSet.size()

    for {y, x} <- answer do
      print(put_in(inp[y][x], "O"))
      IO.puts("")
    end

    answer = MapSet.size(answer)

    # potential_loc? = fn -> end

    # for potential <- visited,

    # answer = MapSet.new()
    IO.inspect(answer, label: "p2")
  end
end
