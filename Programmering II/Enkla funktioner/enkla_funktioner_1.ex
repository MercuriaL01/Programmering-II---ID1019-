defmodule UppgiftExp do

  def even(x) do
    rem(x, 2) == 0
  end

  def exp(x, n) do
    case n do
      0 -> 1
      1 -> x
      _ ->
        if even(n) do
          exp(x, div(n, 2)) * exp(x, div(n, 2))
        else
          exp(x, (n - 1)) * x
        end
    end
  end
end
