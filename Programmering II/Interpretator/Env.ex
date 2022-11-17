defmodule Env do
  def new() do
    []
  end

  def add(id, str, []) do
    [{id, str}]
  end

  def add(id, str, [{id, _} | tail]) do
    [{id, str} | tail]
  end

  def add(id, str, [head|tail]) do
    [head | add(id, str, tail)]
  end

  def lookup(_, []) do
    :nil
  end

  def lookup(id, env) do
    [head|tail] = env
    {a, _} = head
    if a == id do
      head
    else
      lookup(id, tail)
    end
  end

  def addTupleToList(tuple, []) do
    [tuple]
  end

  def addTupleToList(tuple, [l]) do
    [tuple, l]
  end

  def remove([], env) do
    env
  end

  def remove([head|tail], env) do
    remove(tail, remove_helper(head, env))
  end

  def remove_helper(_,[]) do
    []
  end

  def remove_helper(id, [{id, _} | tail]) do
    remove([id], tail)
  end

  def remove_helper(idHead, [envHead|envTail]) do
    [envHead | remove_helper(idHead, envTail)]
  end

  def extract_vars({:var, id}) do
    [id]
  end

  def extract_vars({:cons, a, b}) do
    extract_vars(a) ++ extract_vars(b)
  end

  def extract_vars(_) do [] end

  def closure([{:var, id} | tail], env) do
    case lookup(id, env) do
      {^id, _val} ->
        :error
      nil ->
        closure(tail, add(id, id, env))
    end
  end

  def args(par, strs, closure) do
    closure ++ add(par, strs, new())
  end
end
