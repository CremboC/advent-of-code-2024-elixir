defmodule Util do
  def clean_list(list), do: Enum.filter(list, &(&1 != ""))

  def lines(string),
    do: String.split(string, "\n") |> clean_list()

  def lines_raw(string),
    do: String.split(string, "\n")

  def integer_list_from_str(string),
    do: String.split(string) |> Enum.map(&(Integer.parse(&1) |> elem(0)))

  def integer_list_from_str(string, splitter),
    do: String.split(string, splitter) |> Enum.map(&(Integer.parse(&1) |> elem(0)))

  def string_to_int_list!(lst),
    do: String.graphemes(lst) |> Enum.map(&(Integer.parse(&1) |> elem(0)))

  def int!(string), do: Integer.parse(string) |> elem(0)

  def pairs(lst), do: for(l <- lst, r <- lst, l != r, do: {l, r})

  def uniq_pairs(lst), do: uniq_pairs([], lst)
  def uniq_pairs(acc, []), do: acc

  def uniq_pairs(acc, [head | tail]) do
    for l <- tail, reduce: acc do
      acc -> [{head, l} | acc]
    end
    |> uniq_pairs(tail)
  end
end
