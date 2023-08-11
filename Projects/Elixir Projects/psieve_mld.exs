defmodule Ptup do
   def init(ptup) do
      Agent.start_link(fn -> ptup end, name: :tup)
   end
   def update(pos) do
      Agent.update(:tup, fn(ptup) ->
         ptup |> put_elem(pos,0)
      end)
   end
   def update(fst,lst) do
      # Enum.to_list(fst..div(lst,fst))
      #    |> Enum.map(&(&1*fst))
      #    |> Enum.each(&(update(&1)))
      Stream.iterate(fst*fst,(&(&1+fst)))
         |> Stream.take_while(&(&1<=lst))
         |> Enum.each(&(update(&1)))
   end
   def get do
      Agent.get(:tup, fn(ptup) -> ptup end)
   end
   def get_elem(pos) do
      get() |> elem(pos)
   end
end

defmodule Psieve do
   defp esieve(p,lm,sq) do
      cond do
         p > sq ->
            Ptup.get |> Tuple.to_list |> Enum.filter(&(&1>0))
         Ptup.get_elem(p) == 0 ->
            esieve(p+1,lm,sq)
         true ->
            Ptup.update(p,lm)
            esieve(p+1,lm,sq)
      end
   end
   def psieve(lm) do
      sq = :math.sqrt(lm)
      ns = ([0,0]++Enum.to_list(2..lm)) |> List.to_tuple
      Ptup.init(ns)
      esieve(2,lm,sq)
   end
end

t_st = :os.system_time :millisecond
# List.last(Psieve.psieve(10_000_000)) |> IO.puts
length(Psieve.psieve(100000)) |> IO.puts
# Psieve.psieve(1_000_000)
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"

# Ptup.init({0,1,2,3,4,5,6,7,8,9,10})
# Ptup.update(5)
# Ptup.update(2,10)
# Ptup.get |> inspect |> IO.puts
# Ptup.get_elem(3) |> IO.puts
