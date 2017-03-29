defmodule Telixir.Parallel do
    
    def each(values, task) do
        Enum.each(values, &(run(&1, task)))
    end

    defp run(value, task) do
        spawn fn -> task.(value) end
    end
end