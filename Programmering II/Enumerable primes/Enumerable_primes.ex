defmodule Enumerable_primes do
  def z(n) do
    fn() -> {n, z(n+1)} end
  end

  def filter(fun, f) do
    {p, newFun} = fun.()
    if rem(p, f) != 0 do
      {p, fn() -> filter(newFun, f) end}
    else
      filter(newFun, f)
    end
  end

  def sieve(fun, prime) do
    {n, filterFun} = filter(fun, prime)
    if (n <= prime) do
      sieve(filterFun, n, prime)
    else
      {n, fn() -> sieve(filterFun, n) end}
    end
  end

  def sieve(fun, number, prime) do
    {n, filterFun} = filter(fun, number)
    if (n <= prime) do
      sieve(filterFun, n, prime)
    else
      {n, fn() -> sieve(filterFun, n) end}
    end
  end
end
