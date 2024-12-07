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

  def navigate_p2(dir, loc, inp, obstacles_placed) do
    {ny, nx} = nloc = next_loc(dir, loc)
    ndir = @next[dir]

    case inp[ny][nx] do
      nil ->
        obstacles_placed

      "#" ->
        navigate_p2(ndir, next_loc(ndir, loc), inp, obstacles_placed)

      _ ->
        {say, sax} =
          next_loc_until(inp, ndir, loc, fn
            "#" -> :halt
            nil -> :halt
            _ -> :cont
          end)

        obstacles_placed =
          if inp[say][sax] != nil and
               not MapSet.member?(obstacles_placed, inp[ny][nx]) and
               has_loop?(
                 # new direction if we placed an obstacle infront of us
                 ndir,
                 # next place if we turned now
                 next_loc(ndir, loc),
                 # need to place an obstacle in the next position
                 put_in(inp[ny][nx], "#"),
                 # next_loc(ndir, loc),
                 %{}
               ) do
            MapSet.put(obstacles_placed, nloc)
          else
            obstacles_placed
          end

        navigate_p2(dir, nloc, inp, obstacles_placed)
    end
  end

  def part1 do
    inp = array_2d(input())
    [{ys, xs} = loc] = get_locs_by(inp, &(&1 == "^"))

    inp = put_in(inp[ys][xs], ".")
    answer = navigate(:north, loc, inp, MapSet.new()) |> MapSet.size()

    IO.inspect(answer, label: "p1")
  end

  def part2() do
    inp = array_2d(input())
    [{ys, xs} = loc] = get_locs_by(inp, &(&1 == "^"))

    inp = put_in(inp[ys][xs], ".")
    answer = navigate_p2(:north, loc, inp, MapSet.new())

    IO.inspect(answer |> MapSet.size(), label: "p2")
  end
end
