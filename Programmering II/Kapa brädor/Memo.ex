defmodule Memo do
  #def new() do
  #  []
  #end

  #def add(mem, key, val) do
  #  [{key, val, []}|mem]
  #end

  #def lookup([], _) do
  #  nil
  #end

  #def lookup([{key, val}|_], key) do
  #  val
  #end

  #def lookup([_|rest], key) do
  #  lookup(rest, key)
  #end

  def new() do
    %{}
  end

  def add(mem, key, val) do
    Map.put(mem, :binary.list_to_bin(key), val)
  end

  def lookup(mem, key) do
    Map.get(mem, :binary.list_to_bin(key))
  end

  #def add(mem, key, val) do
  #  Map.put(mem, key, val)
  #end

  #def lookup(mem, key) do
  #  Map.get(mem, key)
  #end

  def cost([]) do
    {0, :na}
  end

  def cost(seq) do
    {cost, tree, _} = cost(seq, Memo.new())
    {cost, tree}
  end

  def cost([s], mem) do
    {0, s, mem}
  end

  #def cost(seq, mem) do
  #  {c, t, mem} = cost(seq, 0, [], [], mem)
  #  {c, t, Memo.add(mem, seq, {c, t})}
  #end

  def cost([s|rest] = seq, mem) do
    {c, t, mem} = cost(rest, s, [s], [], mem)
    {c, t, Memo.add(mem, seq, {c, t})}
  end

  def check(seq, mem) do
    case Memo.lookup(mem, seq) do
      nil ->
        cost(seq, mem)
      {c, t} ->
        {c, t, mem}
    end
  end

  def cost([], l, left, right, mem) do
    {costLeft, newLeft, mem} = check(left, mem)
    {costRight, newRight, mem} = check(right, mem)
    {l + costLeft + costRight, {newLeft, newRight}, mem}
  end

  def cost([s], l, [], right, mem) do
    {costRight, newRight, mem} = check(right, mem)
    {s + l + costRight, {s, newRight}, mem}
  end

  def cost([s], l, left, [], mem) do
    {costLeft, newLeft, mem} = check(left, mem)
    {s + l + costLeft, {newLeft, s}, mem}
  end

  def cost([s|rest], l, left, right, mem) do
    {toLeft, splitLeft, mem} = cost(rest, l+s, [s|left], right, mem)
    {toRight, splitRight, mem} = cost(rest, l+s, left, [s|right], mem)
    if toLeft < toRight do
      {toLeft, splitLeft, mem}
    else
      {toRight, splitRight, mem}
    end
  end

  def bench(n) do
    for i <- 1..n do
      {t,_} = :timer.tc(fn() -> cost(Enum.to_list(1..i)) end)
      IO.puts(" n = #{i}\t t = #{t} us")
    end
  end
end
