defmodule Cmplx do
  def new(r, i) do
    {:complex, r, i}
  end

  def add(_a = {:complex, r1, i1}, _b = {:complex, r2, i2}) do
    {:complex, r1 + r2, i1 + i2}
  end

  def sqr(_a = {:complex, r, i}) do
    {:complex, r * r - i * i, 2 * r * i}
  end

  def abs(_a = {:complex, r, i}) do
    :math.sqrt(r * r + i * i)
  end
end
