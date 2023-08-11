defmodule Prime do
   defp psieve(ns,n,sqr,lim) do
      cond do
         n > sqr ->
            MapSet.new(2..lim) |> MapSet.difference(ns)
         # MapSet.member?(ns,n) ->
         #    psieve(ns,n+2,sqr,lim)
         true ->
            ns = ns |> MapSet.union(MapSet.new((n..div(lim,n)),&(&1*n)))
            psieve(ns,n+2,sqr,lim)
      end
   end
   def sieve(lim) do
      sqr = :math.sqrt(lim)
      ns = (2..div(lim,2)) |> MapSet.new(&(&1*2))
      psieve(ns,3,sqr,lim)
   end
end

t_st = :os.system_time :millisecond
MapSet.size(Prime.sieve(1_000_000)) |> IO.puts
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"
