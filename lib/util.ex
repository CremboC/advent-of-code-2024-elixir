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

  def int!(string), do: Integer.parse(string) |> elem(0)

  def array_2d(string),
    do:
      lines(string)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {ln, y}, acc ->
        %{
          y =>
            String.graphemes(ln)
            |> Enum.with_index()
            |> Enum.reduce(%{}, fn {c, x}, acc -> Map.merge(acc, %{x => c}) end)
        }
        |> Map.merge(acc)
      end)
end
