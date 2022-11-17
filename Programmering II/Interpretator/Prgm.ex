defmodule Prgm do
  def append() do
    {[:x, :y],
      [{:case, {:var, :x},
        [{:clase, {:atm, :nil}, [{:var, :y}]},
          {:clase, {:cons, {:var, :hd}, {:var, :tl}},
            [{:cons,
              {:var, :hd},
              {:call, :append, [{:var, :tl}, {:var, :y}]}}]
        }]
      ]}
    }
  end
end
