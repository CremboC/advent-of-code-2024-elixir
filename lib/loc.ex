defmodule Loc do
  def vector({y, x}, {y_, x_}), do: {y - y_, x - x_}
  def vector_abs({y, x}, {y_, x_}), do: {abs(y - y_), abs(x - x_)}

  def max(a, b) when a == b, do: a
  def max({ya, xa} = a, {yb, xb} = b) when ya == yb, do: if(xa >= xb, do: a, else: b)
  def max({ya, _} = a, {yb, _}) when ya > yb, do: a
  def max(_, b), do: b

  def min(a, b) when a == b, do: a
  def min({ya, xa} = a, {yb, xb} = b) when ya == yb, do: if(xa <= xb, do: a, else: b)
  def min({ya, _} = a, {yb, _}) when ya < yb, do: a
  def min(_, b), do: b

  def add({y, x}, {y_, x_}), do: {y + y_, x + x_}
  def sub({y, x}, {y_, x_}), do: {y - y_, x - x_}

  def hamming({y, x}, {y_, x_}), do: abs(y - y_) + abs(x - x_)

  def valid?({y, x}, inp), do: inp[y][x] != nil

  def loc_abs({y, x}), do: {abs(y), abs(x)}

  def neg({y, x}), do: {-y, -x}
end
