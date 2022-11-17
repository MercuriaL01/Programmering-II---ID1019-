defmodule Eager do
  def eval_expr({:case, expr, cls}, env) do
    case eval_expr(expr, env) do
      :error->
        :error
      {:ok, str} ->
        eval_cls(cls, str, env)
    end
  end

  def eval_expr({:cons, a, b}, env) do
    case eval_expr(a , env) do
      :error ->
        :error
      {:ok, c} ->
        case eval_expr(b , env) do
          :error ->
            :error
          {:ok, ts} ->
            {:ok, {c, ts}}
        end
    end
  end

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil ->
        :error
      {_, str} ->
        {:ok, str}
    end
  end

  def eval_expr({:atm, id}, _) do
    {:ok, id}
  end

  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error ->
        :error
      {:ok, {:closure, par, seq, closure}} ->
        case eval_args(args, env) do
          :error ->
            :error
          {:ok, strs} ->
            env = Env.args(par, strs, closure)
            eval_seq(seq, env)
        end
    end
  end

  eval_expr({:fun id}, env) do
    {par, seq} = apply(Prgm, id, [])
    {:ok, {:closure, par, seq, []}}
  end

  def eval_cls([{:clause, ptr, seq} | cls], str, env) do
    env = eval_scope(ptr, env)
    case eval_match(ptr, str, env) do
      :fail ->
        eval_cls(cls, str, env)
      {:ok, env} ->
        eval_seq(seq, env)
    end
  end

  def eval_cls([], _, _) do
    :error
  end

  def eval_expr({:lambda, par, free, seq}, env) do
    case Env.closure(free, env) do
      :error ->
        :error
      closure ->
        {:ok, {:closure, par, seq, closure}}
    end
  end

  def eval_args(args, env) do
    eval_expr(args, env)
  end

  def eval_match(:ignore, _, env) do
    {:ok, env}
  end

  def eval_match({:atm, id}, id, env) do
    {:ok, env}
  end

  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
    nil ->
      {:ok, Env.add(id, str, env)}
    {^id, ^str} ->
      {:ok, env}
    {_, _} ->
      :fail
    end
  end

  def eval_match({:cons, hp, tp}, {c, d}, env) do
    case eval_match(hp, c, env) do
      :fail ->
        :fail
      {:ok, env} ->
        eval_match(tp, d, env)
    end
  end

  def eval_match(_, _, _) do
    :fail
  end

  def eval_scope(pat, env) do
    Env.remove(Env.extract_vars(pat), env)
  end

  def eval_seq([exp], env) do
    eval_expr(exp, env)
  end

  def eval_seq([{:match, pat, exp} | seq], env) do
    case eval_expr(exp , env) do
      :error ->
        :error
      {:ok, a}  ->
        envB = eval_scope(pat, env)

      case eval_match(pat, a, envB) do
        :fail ->
          :error
        {:ok, envC} ->
          eval_seq(seq, envC)
      end
    end
  end

  def eval(seq) do
    eval_seq(seq, Env.new())
  end
end
