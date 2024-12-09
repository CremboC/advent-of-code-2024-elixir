alias Okasaki.Deque, as: Deq
alias Aja.Vector, as: Vec
import Aja

defmodule Data do
  defstruct [:n, :id, moved: false]
end

defmodule Free do
  defstruct [:n]
end

defmodule Day09 do
  def expand(deq), do: expand(deq, "")

  def expand(deq, acc) do
    case Deq.remove_left(deq) do
      {:ok, {%Data{n: n, id: id}, rest}} ->
        expand(rest, "#{acc}#{String.duplicate(to_string(id), n)}")

      {:ok, {%Free{n: n}, rest}} ->
        expand(rest, "#{acc}#{String.duplicate(".", n)}")

      {_, :empty} ->
        acc
    end
  end

  def print_expand(deq) do
    expand(deq) |> IO.inspect()
    deq
  end

  def checksum_deq(deq), do: checksum_deq(deq, 0, 0)

  def checksum_deq(deq, idx, acc) do
    case Deq.remove_left(deq) do
      {_, :empty} ->
        acc

      {:ok, {%Free{n: n}, rest}} ->
        checksum_deq(rest, idx + n, acc)

      {:ok, {%Data{n: n, id: id}, rest}} ->
        acc =
          for i <- idx..(idx + n - 1), reduce: acc do
            acc -> acc + i * id
          end

        checksum_deq(rest, idx + n, acc)
    end
  end

  def checksum_vec(vec), do: checksum_vec(vec, 0, 0, 0)

  def checksum_vec(vec, data_idx, block_idx, acc) do
    case Vec.at(vec, data_idx) do
      nil ->
        acc

      %Free{n: size} ->
        checksum_vec(vec, data_idx + 1, block_idx + size, acc)

      %Data{n: size, id: id} ->
        acc =
          for i <- block_idx..(block_idx + size - 1), reduce: acc do
            acc -> acc + id * i
          end

        checksum_vec(vec, data_idx + 1, block_idx + size, acc)
    end
  end

  def solve(deq), do: solve(deq, Deq.new())

  def solve(deq, acc) do
    cond do
      Deq.size(deq) == 0 ->
        acc

      Deq.size(deq) == 1 ->
        {:ok, {item, _}} = Deq.remove_left(deq)
        acc |> Deq.insert_right(item)

      true ->
        case Deq.remove_left(deq) do
          {:ok, {%Free{n: hfree} = head, deq}} ->
            case Deq.remove_right(deq) do
              {:ok, {%Data{n: lused, id: lid} = data, deq}} ->
                cond do
                  # we have exactly enough free space
                  hfree == lused ->
                    solve(deq, acc |> Deq.insert_right(data))

                  # we have more free space than needed
                  hfree > lused ->
                    solve(
                      deq |> Deq.insert_left(%Free{n: hfree - lused}),
                      acc |> Deq.insert_right(data)
                    )

                  # we don't have enough free space
                  hfree < lused ->
                    # e.g. we need lused=10
                    # we have hfree=3 => gonna use this much now
                    # lused-hfree=7 => will still need this much
                    solve(
                      deq |> Deq.insert_right(%Data{n: lused - hfree, id: lid}),
                      acc |> Deq.insert_right(%Data{n: hfree, id: lid})
                    )
                end

              {:ok, {%Free{}, deq}} ->
                solve(deq |> Deq.insert_left(head), acc)
            end

          {:ok, {%Data{} = data, deq}} ->
            solve(deq, acc |> Deq.insert_right(data))
        end
    end
  end

  def solve_p2(disk), do: solve_p2(disk, Vec.size(disk) - 1)

  def solve_p2(disk, 0), do: disk

  def solve_p2(disk, p) do
    case Vec.at!(disk, p) do
      %Free{} ->
        solve_p2(disk, p - 1)

      %Data{moved: true} ->
        solve_p2(disk, p - 1)

      %Data{n: dsize, id: id, moved: false} = data ->
        fidx =
          0..(p - 1)
          |> Enum.find_index(fn i ->
            case Vec.at(disk, i) do
              %Free{n: fsize} when dsize <= fsize -> true
              _ -> false
            end
          end)

        if fidx == nil do
          solve_p2(disk, p - 1)
        else
          %Free{n: fsize} = Vec.at!(disk, fidx)
          diff = fsize - dsize
          data = %{data | moved: true}

          cond do
            # fits perfectly
            diff == 0 ->
              # remove data from original location
              # and remove free space from current location
              disk = Vec.replace_at!(disk, p, %Free{n: dsize}) |> Vec.replace_at!(fidx, data)
              solve_p2(disk, p - 1)

            # we have extra free space
            diff > 0 ->
              disk = Vec.replace_at!(disk, p, %Free{n: dsize}) |> Vec.replace_at!(fidx, data)
              {left, right} = Vec.split(disk, fidx + 1)

              disk = left +++ vec([%Free{n: diff}]) +++ right
              solve_p2(disk, p)
          end
        end
    end
  end

  def parse(input) do
    Util.string_to_int_list!(input)
    |> Enum.chunk_every(2, 2)
    |> Enum.with_index()
    |> Enum.flat_map(fn
      {[used, 0], id} -> [%Data{n: used, id: id}]
      {[used, free], id} -> [%Data{n: used, id: id}, %Free{n: free}]
      {[used], id} -> [%Data{n: used, id: id}]
    end)
  end

  def part1(input) do
    input
    |> parse()
    |> Deq.new()
    |> solve()
    |> checksum_deq()
    |> IO.inspect(label: "p1: checksum")
  end

  def part2(input) do
    input
    |> parse()
    |> Vec.new()
    |> solve_p2()
    |> checksum_vec()
    |> IO.inspect(label: "p2: checksum")
  end
end
