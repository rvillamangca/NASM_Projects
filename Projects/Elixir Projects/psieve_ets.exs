# defmodule Primes do
#   def sieve(lm,sq,i) do
#     cond do
#       i > sq ->
#         [2 | Enum.map(:ets.tab2list(:prs), fn {_,i} -> i end)]
#       not(:ets.member(:prs, i)) ->
#         sieve(lm,sq,i+2)
#       true ->
#         Stream.iterate(i*i,&(&1+2*i)) |> Stream.take_while(&(&1<=lm)) |> Stream.each(&(:ets.delete(:prs,&1))) |> Stream.run
#         sieve(lm,sq,i+2)
#     end
#   end
#   def sieve(lim) do
#     :ets.new(:prs, [:ordered_set, :named_table])
#     sqr = :math.sqrt(lim)
#     Stream.iterate(3,&(&1+2)) |> Stream.take_while(&(&1<=lim))  |> Stream.each(&(:ets.insert(:prs,{&1,&1}))) |> Stream.run
#     sieve(lim,sqr,3)
#   end
# end
#
# t_st = :os.system_time :millisecond
# length(Primes.sieve(100_000_000)) |> IO.puts
# t_fn = :os.system_time :millisecond
# IO.puts "\n#{(t_fn - t_st)/1000} seconds"

defmodule Primes do
   defp sieve(lim,sqr,i) do
      cond do
         i > sqr ->
            :ets.tab2list(:prs)
               |> hd
               |> Tuple.to_list
               |> tl
               |> Enum.filter(&(&1))
         :ets.lookup_element(:prs,1,i) ->
            Stream.iterate(i*i,&(&1+2*i))
               |> Stream.take_while(&(&1<=lim))
               |> Stream.each(&(:ets.update_element(:prs,1,{&1,nil})))
               |> Stream.run
            sieve(lim,sqr,i+2)
         true ->
            sieve(lim,sqr,i+2)
      end
   end
   def sieve(lim) do
      sqr = :math.sqrt(lim)
      :ets.new(:prs, [:named_table])
      :ets.insert(:prs, List.to_tuple([1,2,3] ++ Enum.map_every((4..lim), 2, fn _ -> nil end)))
      sieve(lim,sqr,3)
   end
end

t_st = :os.system_time :millisecond
length(Primes.sieve(10_000_000)) |> IO.puts
t_fn = :os.system_time :millisecond
IO.puts "\n#{(t_fn - t_st)/1000} seconds"
