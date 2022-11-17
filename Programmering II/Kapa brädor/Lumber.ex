defmodule Lumber do
  def split(seq) do
    split(seq, 0, [], []) end

  def split([], l, left, right) do
    [{left, right, l}]
  end

  def split([s|rest], l, left, right) do
    split(rest, l + s, [s|left], right) ++ split(rest, l + s, left, [s|right])
  end

  def cost([]) do
    {0, {}}
  end

  def cost([a]) do
    {0, a}
  end

  def cost(seq) do
    cost(seq, 0, [], [])
  end

  def cost([], l, left, right) do
    {costLeft, newLeft} = cost(left)
    {costRight, newRight} = cost(right)
    {l + costLeft + costRight, {newLeft, newRight}}
  end

  def cost([s], l, [], right) do
    {costRight, newRight} = cost(right)
    {s + l + costRight, {s, newRight}}
  end

  def cost([s], l, left, []) do
    {costLeft, newLeft} = cost(left)
    {s + l + costLeft, {newLeft, s}}
  end

  def cost([s|rest], l, left, right) do
    {toLeft, splitLeft} = cost(rest, l+s, [s|left], right)
    {toRight, splitRight} = cost(rest, l+s, left, [s|right])
    if toLeft < toRight do
      {toLeft, splitLeft}
    else
      {toRight, splitRight}
    end
  end

  def bench(n) do
    for i <- 1..n do
      {t,_} = :timer.tc(fn() -> cost(Enum.to_list(1..i)) end)
      IO.puts(" n = #{i}\t t = #{t} us")
    end
  end
end
