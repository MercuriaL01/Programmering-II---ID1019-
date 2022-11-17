defmodule Primes do

  defstruct [:next]

  def primes() do
    %Primes{next: fn() -> {2, fn() -> Enumerable_primes.sieve(Enumerable_primes.z(2), 2) end} end}
  end   #ny

  def next(%Primes{next: fun}) do
    {n, fun2} = fun.()
    {n, %Primes{next: fun2}}
  end

  defimpl Enumerable do

    def count(_) do {:error, __MODULE__} end
    def member?(_, _) do {:error, __MODULE__} end
    def slice(_) do {:error, __MODULE__} end

    def reduce(_, {:halt, acc}, _fun) do
      {:halted, acc}
    end
    def reduce(primes, {:suspend, acc}, fun) do
      {:suspended, acc, fn(cmd) -> reduce(primes, cmd, fun) end}
    end
    def reduce(primes, {:cont, acc}, fun) do
      {p, next} = Primes.next(primes)
      reduce(next, fun.(p, acc), fun)
    end
  end
end
