defmodule Util do
  def lines(string),
    do: String.split(string, "\n") |> Enum.filter(&(&1 != ""))

  def integer_list_from_str(string),
    do: String.split(string, " ") |> Enum.map(&(Integer.parse(&1) |> elem(0)))
end
