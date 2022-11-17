defmodule Derivatan do

  @type literal() ::  {:num, number()} | {:var, atom()}

  @type expr() :: literal()
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}
  | {:ln, expr()}
  | {:div, expr(), expr()}
  | {:sqr, expr()}
  | {:sin, expr()}
  | {:cos, expr()}

  def test1() do
    e = {:add,
          {:mul, {:num, 2}, {:var, :x}},
          {:num, 4}}
    d = derivate(e, :x)
    c = calculate(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def test2() do
    e = {:add,
          {:exp, {:var, :x}, {:num, 3}},
          {:num, 4}}
    d = derivate(e, :x)
    c = calculate(d, :x, 4)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def testLn() do
    e = {:ln, {:mul, {:num, 3}, {:var, :x}}}
    d = derivate(e, :x)
    c = calculate(d, :x, 2)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def testDiv() do
    e = {:div, {:num, 1}, {:var, :x}}
    d = derivate(e, :x)
    c = calculate(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def testSqr() do
    e = {:sqr,
    {:add,
    {:mul, {:num, 2}, {:var, :x}},
    {:num, 4}}}
    d = derivate(e, :x)
    c = calculate(d, :x, 5)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def testSin() do
    e = {:sin, {:add, {:num, 3}, {:var, :x}}}
    d = derivate(e, :x)
    c = calculate(d, :x, 1)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def testCos() do
    e = {:cos, {:add, {:num, 2}, {:var, :x}}}
    d = derivate(e, :x)
    c = calculate(d, :x, 3)
    IO.write("expression: #{pprint(e)}\n")
    IO.write("derivative: #{pprint(d)}\n")
    IO.write("simplified: #{pprint(simplify(d))}\n")
    IO.write("calculated: #{pprint(simplify(c))}\n")
    :ok
  end

  def derivate({:num, _}, _) do {:num, 0} end
  def derivate({:var, v}, v) do {:num, 1} end
  def derivate({:var, _}, _) do {:num, 1} end

  def derivate({:add, e1, e2}, v) do
    {:add, derivate(e1, v), derivate(e2, v)}
  end

  def derivate({:mul, e1, e2}, v) do
    {:add,
      {:mul, derivate(e1, v), e2},
      {:mul, e1, derivate(e2, v)}}
  end

  def derivate({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1}}}, derivate(e, v)}
  end

  def derivate({:ln, {:var, v}}, v) do
    {:div, {:num, 1}, {:var, v}}
  end

  def derivate({:ln, e}, v) do
    {:mul,
    {:div, {:num, 1}, e}, derivate(e, v)}
  end

  def derivate({:div, {:num, 1}, {:var, v}}, v) do
    {:div, {:num, -1}, {:exp, {:var, v}, {:num, 2}}}
  end

  def derivate({:div, {:num, n}, e}, v) do
    {:div, {:mul, {:num, n * -1}, derivate{e, v}}, {:exp, e, {:num, 2}}}
  end

  def derivate({:sqr, {:var, v}, v}) do
    {:div, {:num, 1}, {:mul, {:num, 2}, {:sqr, {:var, v}}}}
  end

  def derivate({:sqr, e}, v) do
    {:div, derivate(e, v), {:mul, {:num, 2}, {:sqr, e}}}
  end

  def derivate({:sin, {:var, v}}, v) do
    {:cos, {:var, v}}
  end

  def derivate({:sin, e}, v) do
    {:mul, derivate(e, v), {:cos, e}}
  end

  def derivate({:cos, {:var, v}}, v) do
    {:mul, {:num, -1}, {:sin, {:var, v}}}
  end

  def derivate({:cos, e}, v) do
    {:mul, derivate(e, v), {:mul, {:num, -1}, {:sin, e}}}
  end

  def calculate({:num, n}, _, _) do {:num, n} end
  def calculate({:var, v}, v, n) do {:num, n} end
  def calculate({:var, v}, _, _) do {:var, v} end
  def calculate({:add, e1, e2}, v, n) do
    {:add, calculate(e1, v, n), calculate(e2, v, n)}
  end
  def calculate({:mul, e1, e2}, v, n) do
    {:mul, calculate(e1, v, n), calculate(e2, v, n)}
  end
  def calculate({:exp, e1, e2}, v, n) do
    {:exp, calculate(e1, v, n), calculate(e2, v, n)}
  end
  def calculate({:ln, e}, v, n) do
    {:ln, calculate(e, v, n)}
  end
  def calculate({:div, e1, e2}, v, n) do
    {:div, calculate(e1, v, n), calculate(e2, v, n)}
  end
  def calculate({:sqr, e}, v, n) do
    {:sqr, calculate(e, v, n)}
  end
  def calculate({:sin, e}, v, n) do
    {:sin, calculate(e, v, n)}
  end
  def calculate({:cos, e}, v, n) do
    {:cos, calculate(e, v, n)}
  end

  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify({:ln, e}) do
    simplify_ln(simplify(e))
  end
  def simplify({:div, e1, e2}) do
    simplify_div(simplify(e1), simplify(e2))
  end
  def simplify(:sqr, e) do
    simplify_sqr(simplify(e))
  end
  def simplify(:sin, e) do
    simplify_sin(simplify(e))
  end
  def simplify(:cos, e) do
    simplify_cos(simplify(e))
  end
  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:div, e1, e2}, e3) do {:div, {:mul, e1, e3}, e2} |> simplify() end  #Here I use the pipe operator to simplify again
  def simplify_mul(e1, {:div, e2, e3}) do {:div, {:mul, e1, e2}, e3}  |> simplify() end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def simplify_ln({:num, 1}) do {:num, 0} end
  def simplify_ln(e) do {:ln, e} end

  def simplify_div({:num, 0}, _) do {:num, 0} end
  def simplify_div(e, {:num, 1}) do e end
  def simplify_div({:num, n1}, {:num, n2}) do {:num, n1/n2} end
  def simplify_div(e, e) do {:num, 1} end
  def simplify_div({:mul, e1, e2}, e1) do e2 end
  def simplify_div({:mul, e1, e2}, e2) do e1 end
  def simplify_div(e1, {:mul, e1, e2}) do {:div, {:num, 1}, e2} end
  def simplify_div(e2, {:mul, e1, e2}) do {:div, {:num, 1}, e1} end
  def simplify_div(e1, e2) do {:div, e1, e2} end

  def simplify_sqr({:num, n}) do {:num, :math.sqrt(n)} end
  def simplify_sqr({e}) do {:sqr, e} end

  def simplify_sin({:sin, {:num, n}}) do {:num, :math.sin(n)} end
  def simplify_sin({:sin, e}) do {:sin, e} end

  def simplify_cos({:cos, {:num, n}}) do {:num, :math.cos(n)} end
  def simplify_cos({:cos, e}) do {:cos, e} end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "(#{pprint(e1)} * #{pprint(e2)})" end
  def pprint({:exp, e1, e2}) do "(#{pprint(e1)})^(#{pprint(e2)})" end
  def pprint({:ln, e}) do "ln(#{pprint(e)})" end
  def pprint({:div, n, e}) do "(#{pprint(n)} / #{pprint(e)})" end
  def pprint({:sqr, e}) do "sqrt(#{pprint(e)})" end
  def pprint({:sin, e}) do "sin(#{pprint(e)})" end
  def pprint({:cos, e}) do "cos(#{pprint(e)})" end
end
