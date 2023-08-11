defmodule Psieve do
   defp esieve(p,ns,lm,sq) do
      cond do
         p > sq ->
            ns |> Enum.filter(&(&1>0))
         Enum.fetch!(ns,p) == 0 ->
            # IO.puts(p)
            esieve(p+1,ns,lm,sq)
         true ->
            # IO.puts(p)
            ns_low = ns |> Enum.slice(0..p*p-1)
            ns_high = ns |> Enum.slice(p*p..lm) |> Enum.map_every(p,fn _ -> 0 end)
            esieve(p+1,ns_low++ns_high,lm,sq)
      end
   end
   def psieve(lm) do
      sq = :math.sqrt(lm)
      ns = [0,0]++Enum.to_list(2..lm)
      esieve(2,ns,lm,sq)
   end
end

t_st = :os.system_time :millisecond
# List.last(Psieve.psieve(10_000_000)) |> IO.puts
inspect(Psieve.psieve(1000000)) |> IO.puts
# Psieve.psieve(1_000_000)
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"
