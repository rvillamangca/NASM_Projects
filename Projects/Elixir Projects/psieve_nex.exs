defmodule Prime do
   defp psieve(ps,ns,lm,sq) do
      if List.first(ns) > sq do
        ps ++ ns
      else
        [h|ts] = ns
        s = h * h
        r = h * 2
        ps = ps ++ [h]
        ns = ts -- (Stream.iterate(s,&(&1+r)) |> Enum.take_while(&(&1 <= lm)))
        psieve(ps,ns,lm,sq)
      end
  end
  def sieve(lm) do
      sq = :math.sqrt(lm)
      ps = [2]
      ns = [3] ++ Enum.drop_every((4..lm),2)
      psieve(ps,ns,lm,sq)
  end
end

t_st = :os.system_time :millisecond
length(Prime.sieve(10_000_000)) |> IO.puts
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"
