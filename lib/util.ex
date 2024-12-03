defmodule Util do
  def lines(string),
    do: String.split(string, "\n") |> Enum.filter(&(&1 != ""))

  def integer_list_from_str(string, splitter \\ " "),
    do: String.split(string, splitter) |> Enum.map(&(Integer.parse(&1) |> elem(0)))

  def int!(string), do: Integer.parse(string) |> elem(0)
end
