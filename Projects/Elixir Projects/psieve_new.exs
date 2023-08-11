defmodule Prime do
  defp sieve(ps,i,sq) do
      p = ps |> Enum.at(i)
      cond do
         p > sq ->
            ps |> Enum.reject(&(&1==0))
         p == 0 ->
            sieve(ps,i+1,sq)
         true ->
            ts = ps |> Enum.split(p*p)
            ps = elem(ts,0) ++ (elem(ts,1) |> Enum.map_every(p*2,fn _ -> 0 end))
            sieve(ps,i+1,sq)
      end
  end
  def sieve(lm) do
      sq = :math.sqrt(lm)
      ps = [0,0,2,3] ++ Enum.map_every((4..lm),2,fn _ -> 0 end)
      sieve(ps,3,sq)
  end
end

t_st = :os.system_time :millisecond
length(Prime.sieve(1_000_000)) |> IO.puts
# Prime.sieve(100) |> IO.inspect
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"
