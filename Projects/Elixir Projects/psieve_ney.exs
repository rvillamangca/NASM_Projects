defmodule Prime do
  defp psieve(ps,ns,i,sq) do
      p = ps |> Enum.at(i)
      if p > sq do
        ps ++ ns
      else
        s = p * p
        ps = ps ++ (ns |> Enum.take_while(&(&1<s)))
        ns = ns |> Enum.drop_while(&(&1<s)) |> Enum.reject(&(rem(&1,p)==0))
        psieve(ps,ns,i+1,sq)
      end
  end
  def sieve(lm) do
      sq = :math.sqrt(lm)
      ps = [2,3]
      ns = Enum.drop_every((4..lm),2)
      psieve(ps,ns,1,sq)
  end
end

t_st = :os.system_time :millisecond
length(Prime.sieve(1_000_000)) |> IO.puts
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"
