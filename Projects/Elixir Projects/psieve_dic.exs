defmodule Primes do
   defp update(prs,x,i,lim) do
      if x > lim do
         prs
      else
         update(%{prs|x=>0},x+i,i,lim)
      end
   end
   defp psieve(prs,i,lim,sq) do
      cond do
         i > sq       ->  prs |> Map.values |> Enum.filter(&(&1>1)) |> Enum.sort
         prs[i] == 0  ->  psieve(prs,i+1,lim,sq)
         true         ->  psieve(update(prs,i*i,i,lim),i+1,lim,sq)
      end
   end
   def sieve(lim) do
      prs = 0..lim |> Enum.map(&({&1,&1})) |> Map.new
      sq = :math.sqrt(lim)
      psieve(prs,2,lim,sq)
   end
end

t_st = :os.system_time :millisecond
Primes.sieve(1_000_000) |> length |> IO.puts
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"
