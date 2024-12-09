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

  # for each data block
  # go from the left side, attempting to find a free space where idx(free) < idx(data_block)
  #
  def solve_p2_2(disk), do: solve_p2_2(disk, Vec.size(disk) - 1)

  def solve_p2_2(disk, 0), do: disk

  def solve_p2_2(disk, p) do
    # print_expand(disk |> Vec.to_list() |> Deq.new())
    # IO.inspect(p, label: "pointer")

    case Vec.at!(disk, p) do
      %Free{} ->
        solve_p2_2(disk, p - 1)

      %Data{moved: true} ->
        solve_p2_2(disk, p - 1)

      %Data{n: dsize, moved: false} = data ->
        fidx =
          0..(p - 1)
          |> Enum.find_index(fn i ->
            case Vec.at!(disk, i) do
              %Free{n: fsize} when dsize <= fsize -> true
              _ -> false
            end
          end)

        if fidx == nil do
          solve_p2_2(disk, p - 1)
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
              solve_p2_2(disk, p - 1)

            # we have extra free space
            diff > 0 ->
              disk = Vec.replace_at!(disk, p, %Free{n: dsize}) |> Vec.replace_at!(fidx, data)
              {left, right} = Vec.split(disk, fidx + 1)

              disk = left +++ vec([%Free{n: diff}]) +++ right
              solve_p2_2(disk, p - 1)
          end
        end
    end
  end

  # def solve_p2(disk) do
  #   p1 =
  #     Enum.find_index(disk, fn
  #       %Free{} -> true
  #       _ -> false
  #     end)

  #   p2 = Vec.size(disk) - 1

  #   solve_p2(disk, p1, p2)
  # end

  # def solve_p2(disk, p1, p2) when p1 == p2, do: disk

  # def solve_p2(disk, p1, p2) do
  #   # print_expand(disk |> Vec.to_list() |> Deq.new())

  #   case Vec.at!(disk, p1) do
  #     %Data{} ->
  #       solve_p2(disk, p1 + 1, p2)

  #     %Free{n: free} ->
  #       {idx, data} =
  #         p2..p1//-1
  #         |> Enum.map(fn i -> {i, Vec.at!(disk, i)} end)
  #         |> Enum.find({0, nil}, fn
  #           {_, %Data{n: size, moved: false}} when size <= free ->
  #             true

  #           _ ->
  #             false
  #         end)

  #       if data == nil do
  #         solve_p2(disk, p1 + 1, p2)
  #       else
  #         diff = free - data.n
  #         data = %{data | moved: true}

  #         cond do
  #           # fits perfectly
  #           diff == 0 ->
  #             # remove data from original location
  #             # and remove free space from current location
  #             disk = Vec.replace_at!(disk, idx, %Free{n: data.n}) |> Vec.replace_at!(p1, data)
  #             solve_p2(disk, p1 + 1, p2)

  #           # we have extra free space
  #           diff > 0 ->
  #             disk = Vec.replace_at!(disk, idx, %Free{n: data.n}) |> Vec.replace_at!(p1, data)
  #             {left, right} = Vec.split(disk, p1 + 1)

  #             disk = left +++ vec([%Free{n: diff}]) +++ right

  #             solve_p2(disk, p1 + 1, p2)
  #         end
  #       end
  #   end
  # end

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
    # |> print_expand()
    # |> solve_p2() # 6422354846267
    # 6457255431661, 6457255431661, 6457255431661, 6457258710389
    |> solve_p2_2()
    # |> IO.inspect()
    # |> Vec.to_list()
    # |> Deq.new()
    # |> IO.inspect()
    # |> print_expand()
    |> checksum_vec()
    |> IO.inspect(label: "p2: checksum")

    insert_between(vec([0, 1, 2]), 2, "hi") |> IO.inspect()

    # checksum_vec(vec([%Data{n: 2, id: 0}, %Data{n: 2, id: 9}, %Data{n: 1, id: 8}]))
    # |> IO.inspect()
  end

  def insert_between(vec, idx, item) do
    {l, r} = Vec.split(vec, idx)
    l +++ vec([item]) +++ r
  end
end
