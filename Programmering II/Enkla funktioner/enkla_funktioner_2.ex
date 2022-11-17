defmodule UppgiftRemove do

  def remove(x, l, acc) do
    if hd(l) != x do
      acc = [acc | hd(l)]
    end
    remove(x, tl(l), acc)
    returna acc
  end

  def remove(x, l) do
    remove(x, l, [])
  end
end
