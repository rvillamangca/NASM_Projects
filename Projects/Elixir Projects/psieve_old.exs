defmodule Psieve do
   # defp rem_mults(h,ts,lm) do
   defp rem_mults(h,ts) do
      # ts -- ((h..div(lm,h)) |> Enum.map(&(&1*h)))
      # ts -- ((h*h..lm) |> Enum.take_every(h))
      # ts -- ((h..lm) |> Task.async_stream(&(&1*h)) |> Enum.take_while(&(&1<=div(lm,h))))
      # ts -- ((h..div(lm,h)) |> Stream.map(&(&1*h)) |> Enum.to_list)
      # ts -- ((h..div(lm,h)) |> Task.async_stream(&(&1*h)) |> Enum.map(&(elem(&1,1))))
      s = h * h
      (ts |> Enum.take_while(&(&1<s))) ++ (ts |> Enum.drop_while(&(&1<s)) |> Enum.filter(&(rem(&1,h)>0)))
   end
   defp esieve(ps,ns,lm,sq) do
      if List.last(ps) > sq do
         ps ++ ns
      else
         [h|ts] = ns
         # esieve((ps++[h]),rem_mults(h,ts,lm),lm,sq)
         esieve((ps++[h]),rem_mults(h,ts),lm,sq)
      end
   end
   def psieve(lm) do
      sq = :math.sqrt(lm)
      esieve([2],Enum.map(Enum.to_list(1..div(lm-1,2)),&(&1*2+1)),lm,sq)
      # ns = Stream.iterate(3,&(&1+2)) |> Enum.take_while(&(&1 <= lm))
      # esieve([2],ns,lm,sq)
   end
end

t_st = :os.system_time :millisecond
# List.last(Psieve.psieve(10_000_000)) |> IO.puts
length(Psieve.psieve(1_000_000)) |> IO.puts
# Psieve.psieve(1_000_000)
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"
