# defmodule M do
#    def sum_div(a,b,c) do
#       a..div(b,abs(c)) |> Enum.map(&(&1 * c)) |> Enum.sum
#    end
#    def run() do
#       lim = 100_000_000
#       [3,5,-15] |> Enum.map(&(M.sum_div(1,lim-1,&1))) |> Enum.sum |> IO.puts
#    end
# end

defmodule M do
   def sum_upto(a) do
      div(a*(a+1),2)
   end
   def lcm(a,b) do
      div((a*b),Integer.gcd(a,b))
   end
   def sum_div(a,b) do
      sum_upto(div(a,abs(b))) * b
   end
   def run() do
      lim = 1_000
      [3,5,-(lcm(3,5))] |> Enum.map(&(sum_div(lim-1,&1))) |> Enum.sum |> IO.puts
   end
end

M.run()
