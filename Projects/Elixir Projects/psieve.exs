defmodule Psieve do
   defp rem_mults(h,ts) do
      ts -- (Enum.to_list(h..div(List.last(ts),h)) |> Enum.map(&(&1*h)))
      # ts -- (Stream.iterate(h*h,(&(&1+h))) |> Enum.take_while(&(&1 <= List.last(ts))))
      # ts_low = ts |> Enum.take_while(&(&1<h*h))
      # ts_high = ts |> Enum.drop_while(&(&1<h*h))
      # ts_low ++ (ts_high |> Enum.drop_every(h))
   end
   defp esieve(ps,ns,sq) do
      if List.last(ps) > sq do
         ps ++ ns
      else
         [h|ts] = ns
         esieve((ps++[h]),rem_mults(h,ts),sq)
      end
   end
   def psieve(lm) do
      sq = :math.sqrt(lm)
      esieve([2],Enum.map(Enum.to_list(1..div(lm-1,2)),&(&1*2+1)),sq)
      # ns = Stream.iterate(3,&(&1+2)) |> Enum.take_while(&(&1 <= lm))
      # esieve([2],ns,sq)
   end
end

t_st = :os.system_time :millisecond
# List.last(Psieve.psieve(10_000_000)) |> IO.puts
length(Psieve.psieve(1_000_000)) |> IO.puts
# Psieve.psieve(1_000_000)
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"
