defmodule M do
   def sum_div(a,b,c) do
      a..div(b,abs(c)) |> Enum.map(&(&1 * c)) |> Enum.sum
   end
   def run() do
      lim = 1000
      [3,5,-15] |> Enum.map(&(M.sum_div(1,lim-1,&1))) |> Enum.sum |> IO.puts
   end
end

M.run()
